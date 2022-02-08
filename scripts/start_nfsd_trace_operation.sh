#!/bin/bash

OP=start

function enable_switch()
{
    echo 1 > /sys/kernel/debug/tracing/tracing_on 
}

function disable_switch()
{
    echo 0 > /sys/kernel/debug/tracing/tracing_on 
}

function enable_nfsd_probe()
{
    echo 'p:myprobe_nfsd4_open nfsd4_open peer_ip=+44(%di):u32 filename=+0(+16(%dx)):string rq_xid=+6784(%di):u32 op_seqid=+192(%dx):u32'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 'r:myprobe_ret_nfsd4_open nfsd4_open status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_open/enable
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_open/enable
    
    echo 'p:myprobe_nfsd4_process_open2 nfsd4_process_open2 peer_ip=+44(%di):u32 filename=+0(+40(+136(%si))):string  rq_xid=+6784(%di):u32'  >> /sys/kernel/debug/tracing/kprobe_events 
    echo 'r:myprobe_ret_nfsd4_process_open2 nfsd4_process_open2 status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_process_open2/enable
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_process_open2/enable

    echo 'p:myprobe_nfsd4_open_confirm nfsd4_open_confirm peer_ip=+44(%di):u32 filename=+0(+40(+136(%si))):string rq_xid=+6784(%di):u32 oc_seqid=+16(%dx):u32'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 'r:myprobe_ret_nfsd4_open_confirm nfsd4_open_confirm status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_open_confirm/enable
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_open_confirm/enable
    
    echo 'p:myprobe_nfsd4_lookup nfsd4_lookup peer_ip=+44(%di):u32 filename=+0(+8(%dx)):string'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 'r:myprobe_ret_nfsd4_lookup nfsd4_lookup status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_lookup/enable
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_lookup/enable
    
    echo 'p:myprobe_nfsd4_close nfsd4_close peer_ip=+44(%di):u32 filename=+0(+40(+136(%si))):string cl_seqid=+0(%dx):u32'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 'r:myprobe_ret_nfsd4_close nfsd4_close status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_close/enable
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_close/enable

    echo 'p:myprobe_nfsd4_remove nfsd4_remove peer_ip=+44(%di):u32 filename=+0(+8(%dx)):string'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 'r:myprobe_ret_nfsd4_remove nfsd4_remove status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_remove/enable
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_remove/enable

    echo 'p:myprobe_nfsd4_rename nfsd4_rename peer_ip=+44(%di):u32 src_filename=+0(+8(%dx)):string dst_filename=+0(+24(%dx)):string'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 'r:myprobe_ret_nfsd4_rename nfsd4_rename status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_rename/enable
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_rename/enable

    echo 'p:myprobe_nfsd4_lock nfsd4_lock peer_ip=+44(%di):u32 filename=+0(+40(+136(%si))):string lk_is_new=+24(%dx):u32 new_open_seqid=+32(%dx):u32 old_lock_seqid=+48(%dx):u32'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 'r:myprobe_ret_nfsd4_lock nfsd4_lock status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_lock/enable
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_lock/enable

    echo 'p:myprobe_nfsd4_create nfsd4_create peer_ip=+44(%di):u32 filename=+0(+8(%dx)):string'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 'r:myprobe_ret_nfsd4_create nfsd4_create status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_create/enable
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_create/enable


    echo 'p:myprobe_nfsd4_access nfsd4_access peer_ip=+44(%di):u32 filename=+0(+40(+136(%si))):string ac_req_access=+0(%dx):u32'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 'r:myprobe_ret_nfsd4_access nfsd4_access status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_access/enable
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_access/enable

    echo 'p:myprobe_nfsd4_nfsd4_delegreturn nfsd4_nfsd4_delegreturn peer_ip=+44(%di):u32 filename=+0(+40(+136(%si))):string'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 'r:myprobe_ret_nfsd4_nfsd4_delegreturn nfsd4_nfsd4_delegreturn status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_nfsd4_delegreturn/enable
    echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_nfsd4_delegreturn/enable

    #echo 'p:myprobe_nfsd4_read nfsd4_read peer_ip=+44(%di):u32 filename=+0(+40(+136(%si))):string'  >> /sys/kernel/debug/tracing/kprobe_events
    #echo 'r:myprobe_ret_nfsd4_read nfsd4_read status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    #echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_read/enable
    #echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_read/enable

    #echo 'p:myprobe_nfsd4_write nfsd4_write peer_ip=+44(%di):u32 filename=+0(+40(+136(%si))):string'  >> /sys/kernel/debug/tracing/kprobe_events
    #echo 'r:myprobe_ret_nfsd4_write nfsd4_write status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    #echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_write/enable
    #echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_write/enable

    #echo 'p:myprobe_nfsd4_commit nfsd4_commit peer_ip=+44(%di):u32 filename=+0(+40(+136(%si))):string'  >> /sys/kernel/debug/tracing/kprobe_events
    #echo 'r:myprobe_ret_nfsd4_commit nfsd4_commit status=$retval'  >> /sys/kernel/debug/tracing/kprobe_events
    #echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_commit/enable
    #echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_commit/enable
}


function disable_nfsd_probe()
{
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_open/enable
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_open/enable
    echo '-:myprobe_nfsd4_open'  >> /sys/kernel/debug/tracing/kprobe_events
    echo '-:myprobe_ret_nfsd4_open'  >> /sys/kernel/debug/tracing/kprobe_events
    
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_process_open2/enable
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_process_open2/enable
    echo '-:myprobe_nfsd4_process_open2'  >> /sys/kernel/debug/tracing/kprobe_events 
    echo '-:myprobe_ret_nfsd4_process_open2'  >> /sys/kernel/debug/tracing/kprobe_events

    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_open_confirm/enable
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_open_confirm/enable
    echo '-:myprobe_nfsd4_open_confirm'  >> /sys/kernel/debug/tracing/kprobe_events
    echo '-:myprobe_ret_nfsd4_open_confirm'  >> /sys/kernel/debug/tracing/kprobe_events
    
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_lookup/enable
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_lookup/enable
    echo '-:myprobe_nfsd4_lookup'  >> /sys/kernel/debug/tracing/kprobe_events
    echo '-:myprobe_ret_nfsd4_lookup'  >> /sys/kernel/debug/tracing/kprobe_events
    
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_close/enable
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_close/enable
    echo '-:myprobe_nfsd4_close'  >> /sys/kernel/debug/tracing/kprobe_events
    echo '-:myprobe_ret_nfsd4_close'  >> /sys/kernel/debug/tracing/kprobe_events

    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_remove/enable
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_remove/enable
    echo '-:myprobe_nfsd4_remove'  >> /sys/kernel/debug/tracing/kprobe_events
    echo '-:myprobe_ret_nfsd4_remove'  >> /sys/kernel/debug/tracing/kprobe_events

    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_rename/enable
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_rename/enable
    echo '-:myprobe_nfsd4_rename'  >> /sys/kernel/debug/tracing/kprobe_events
    echo '-:myprobe_ret_nfsd4_rename'  >> /sys/kernel/debug/tracing/kprobe_events

    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_lock/enable
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_lock/enable
    echo '-:myprobe_nfsd4_lock'  >> /sys/kernel/debug/tracing/kprobe_events
    echo '-:myprobe_ret_nfsd4_lock'  >> /sys/kernel/debug/tracing/kprobe_events

    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_create/enable
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_create/enable
    echo '-:myprobe_nfsd4_create'  >> /sys/kernel/debug/tracing/kprobe_events
    echo '-:myprobe_ret_nfsd4_create'  >> /sys/kernel/debug/tracing/kprobe_events


    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_access/enable
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_access/enable
    echo '-:myprobe_nfsd4_access'  >> /sys/kernel/debug/tracing/kprobe_events
    echo '-:myprobe_ret_nfsd4_access'  >> /sys/kernel/debug/tracing/kprobe_events

    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_nfsd4_delegreturn/enable
    echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_nfsd4_delegreturn/enable
    echo '-:myprobe_nfsd4_nfsd4_delegreturn'  >> /sys/kernel/debug/tracing/kprobe_events
    echo '-:myprobe_ret_nfsd4_nfsd4_delegreturn'  >> /sys/kernel/debug/tracing/kprobe_events

    #echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_read/enable
    #echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_read/enable
    #echo '-:myprobe_nfsd4_read'  >> /sys/kernel/debug/tracing/kprobe_events
    #echo '-:myprobe_ret_nfsd4_read'  >> /sys/kernel/debug/tracing/kprobe_events

    #echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_write/enable
    #echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_write/enable
    #echo '-:myprobe_nfsd4_write'  >> /sys/kernel/debug/tracing/kprobe_events
    #echo '-:myprobe_ret_nfsd4_write'  >> /sys/kernel/debug/tracing/kprobe_events

    #echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_nfsd4_commit/enable
    #echo 0 > /sys/kernel/debug/tracing/events/kprobes/myprobe_ret_nfsd4_commit/enable
    #echo '-:myprobe_nfsd4_commit'  >> /sys/kernel/debug/tracing/kprobe_events
    #echo '-:myprobe_ret_nfsd4_commit'  >> /sys/kernel/debug/tracing/kprobe_events
}




case $OP in
 "start")
    enable_nfsd_probe
    enable_switch
    ;;
 "stop")
    disable_nfsd_probe
    disable_switch
    ;;
esac
