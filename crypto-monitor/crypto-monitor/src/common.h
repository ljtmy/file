#ifndef CRYPTO_MONITOR_COMMON_H
#define CRYPTO_MONITOR_COMMON_H

#ifndef __VMLINUX_H__
#include <linux/types.h>
#endif

#define TASK_COMM_LEN 16
#define HIST_SLOTS 64

enum monitor_event_type {
  MONITOR_EVENT_NONE = 0,
  MONITOR_EVENT_SNAPSHOT = 1,
  MONITOR_EVENT_CRYPTO = 2,
};

struct monitor_filter {
  __u32 target_tgid;
  __u32 target_tid;
};

struct thread_metrics {
  __u64 cpu_time_ns;
  __u64 context_switches;
  __u64 voluntary_switches;
  __u64 involuntary_switches;
  __u64 sched_latency_samples;
  __u64 sched_latency_total_ns;
  __u64 sched_latency_max_ns;
  __u64 crypto_calls;
  __u64 crypto_errors;
  __u64 crypto_time_ns;
  char comm[TASK_COMM_LEN];
  __u64 sched_latency_hist[HIST_SLOTS];
};

struct histogram_bucket {
  __u64 slot;
  __u64 count;
};

#endif
