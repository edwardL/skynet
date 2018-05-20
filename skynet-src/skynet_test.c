#include "skynet.h"
#include "skynet_test.h"
#include "spinlock.h"

#include <time.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

#if defined(__APPLE__)
#include <AvailabilityMacros.h>
#include <sys/time.h>
#include <mach/task.h>
#include <mach/mach.h>
#endif

struct test_node {
    struct test_node *next;
    uint32_t expire;
};

struct link_list {
    struct test_node head;
    struct test_node *tail;
};

struct test_timer {
    struct link_list near[100];
    struct spinlock lock;
    uint32_t time;
    uint32_t starttime;
    uint64_t current;
    uint64_t current_point;
};

static struct test_timer* TI = NULL;

static inline struct test_node *
link_clear(struct link_list *list) {
    struct test_node * ret = list->head.next;
    list->head.next = 0;
    list->tail = &(list->head);
    
    return ret;
}

static uint64_t
gettime() {
    uint64_t t;
#if !defined(__APPLE__) || defined(AVAILABLE_MAC_OS_X_VERSION_10_12_AND_LATER)
    struct timespec ti;
    clock_gettime(CLOCK_MONOTONIC,&ti);
    t = (uint64_t)ti.tv_sec * 100;
    t += ti.tv_nsec / 10000000;
#else
    struct timeval tv;
    gettimeofday(&tv, NULL);
    t = (uint64_t)tv.tv_sec * 100;
    t += tv.tv_usec / 10000;
#endif
    return t;
}

void
skynet_updatetest(void) {
    uint64_t cp = gettime();
    // printf("%lu\n",cp);
}