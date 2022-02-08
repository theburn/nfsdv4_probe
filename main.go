package main

import (
	"bytes"
	"embed"
	"encoding/binary"
	"net"
	"os"
	"os/exec"
	"os/signal"
	"runtime/debug"
	"strconv"
	"strings"
	"syscall"
	"time"

	"github.com/natefinch/lumberjack"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

//go:embed scripts/*.sh
var content embed.FS

var bootTimeNanoSec int64

var sugarLogger *zap.SugaredLogger

func InitLogger() {
	writeSyncer := getLogWriter()
	encoder := getEncoder()
	core := zapcore.NewCore(encoder, writeSyncer, zapcore.DebugLevel)
	logger := zap.New(core, zap.AddCaller())
	sugarLogger = logger.Sugar()
}

func getEncoder() zapcore.Encoder {
	encoderConfig := zap.NewProductionEncoderConfig()
	encoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	encoderConfig.EncodeLevel = zapcore.CapitalLevelEncoder
	return zapcore.NewConsoleEncoder(encoderConfig)
}

func getLogWriter() zapcore.WriteSyncer {
	lumberJackLogger := &lumberjack.Logger{
		Filename:   "./trace.log",
		MaxSize:    200,
		MaxBackups: 1024,
		MaxAge:     30,
		Compress:   false,
		LocalTime:  true,
	}
	return zapcore.AddSync(lumberJackLogger)
}

func getBootDateTime() {
	var uptimeSec, uptimeNanoSec float64
	file, err := os.ReadFile("/proc/uptime")
	now := time.Now().UnixNano()
	if err != nil {
		sugarLogger.Errorf("open /proc/uptime error: %s", err.Error())
		os.Exit(1)
	}

	text := string(file)
	parts := strings.Split(text, " ")
	uptimeSec, err = strconv.ParseFloat(parts[0], 10)
	if err != nil {
		sugarLogger.Errorf("uptime string parse error: %s", err.Error())
		os.Exit(2)
	}

	uptimeNanoSec = uptimeSec * 1000 * 1000 * 1000 // nanosecond

	bootTimeNanoSec = now - int64(uptimeNanoSec)

	t := time.Unix(0, bootTimeNanoSec)

	sugarLogger.Infof("OS Boot Datetime: %s", (t.Format("2006-01-02, 15:04:05")))
}

var traceEventChan <-chan *TraceEvent
var errChan <-chan error

var trace_pipe *TracePipe

func InitTracePipe() {
	trace, err := NewTracePipe()
	if err != nil {
		sugarLogger.Errorf("New Trace Pipe error:%s", err.Error())
		os.Exit(3)
	}
	trace_pipe = trace

	traceEventChan, errChan = trace.Channel()
}

func nfsdTraceHandler() {
	defer func() {
		if r := recover(); r != nil {
			sugarLogger.Errorf("Recover from:", r)
			sugarLogger.Errorf("stacktrace from panic: \n" + string(debug.Stack()))
		}
	}()

	InitTracePipe()

	for {
		select {
		case err := <-errChan:
			sugarLogger.Errorf("read trace_pipe error: %s", err.Error())
		case traceEvent := <-traceEventChan:
			parseOutput(traceEvent)
		}
	}
}

// you can update it
func parseOutput(ev *TraceEvent) {
	numTimestamp, err := strconv.ParseFloat(ev.Timestamp, 64)
	if err != nil {
		sugarLogger.Errorf("event timestamp convert error: %s", err.Error())
		return
	}

	timestamp := numTimestamp * 1000 * 1000 * 1000 //nanosecond
	msg := ev.Message
	realmsg := "|  eventTime: "

	absTimestamp := bootTimeNanoSec + int64(timestamp)
	absT := time.Unix(0, absTimestamp)
	absDatetime := absT.Format("2006-01-02 15:04:05.999999999")
	realmsg = realmsg + absDatetime

	idx := strings.Index(msg, "peer_ip=")
	if idx >= 0 {
		ip_str := msg[idx+8 : idx+18]
		ip_int, _ := strconv.ParseInt(ip_str, 0, 64)
		net_ip := int2ip(uint32(ip_int))
		realmsg = realmsg + " client_ip: " + net_ip.String()
	}

	realmsg = realmsg + " func: " + ev.Function + " msg: " + msg

	sugarLogger.Info(realmsg)

}

func int2ip(nn uint32) net.IP {
	ip := make(net.IP, 4)
	binary.LittleEndian.PutUint32(ip, nn)
	return ip
}

func doTrace(action string) {
	var stdout, stderr bytes.Buffer
	filename := "scripts/" + action + "_nfsd_trace_operation.sh"

	Cmd := exec.Command("bash")

	f, err := content.Open(filename)

	if err != nil {
		sugarLogger.Errorf("%s trace error: %s", action, err.Error())
		goto _exit
	}

	defer f.Close()

	Cmd.Stdin = f
	Cmd.Stdout = &stdout
	Cmd.Stderr = &stderr

	if err := Cmd.Start(); err != nil {
		sugarLogger.Errorf("%s trace error: %s", action, err.Error())
		goto _exit
	} else {
		if err := Cmd.Wait(); err != nil {
			status := Cmd.ProcessState.Sys().(syscall.WaitStatus)
			exitStatus := status.ExitStatus()
			signaled := status.Signaled()
			signal := status.Signal()

			if signaled {
				sugarLogger.Errorf("recive signal exitStatus:%s, signal:%d", exitStatus, signal)
				goto _exit
			} else {
				sugarLogger.Errorf("%s trace, exit error: %s", action, err.Error())
				goto _exit
			}
		} else {
			sugarLogger.Infof("%s trace success!", action)
			return
		}
	}

_exit:
	sugarLogger.Errorf("%s error, stdout:%s, stderr:%s", action, stdout.String(), stderr.String())
	os.Exit(3)
}

func startTrace() {
	doTrace("start")
}

func stopTrace() {
	doTrace("stop")
}

func trapSignal() {
	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)
	sig := <-sigs
	sugarLogger.Infof("trap signal:%v", sig)
	stopTrace()
	os.Exit(0)
}

func main() {
	InitLogger()
	defer sugarLogger.Sync()

	go trapSignal()

	startTrace()

	getBootDateTime()

	nfsdTraceHandler()

}
