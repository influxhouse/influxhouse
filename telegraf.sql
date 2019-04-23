create database telegraf;

create table telegraf.cpu
(
    time             DateTime,
    host             String,
    cpu              String,
    usage_guest      Float64,
    usage_system     Float64,
    usage_nice       Float64,
    usage_irq        Float64,
    usage_softirq    Float64,
    usage_steal      Float64,
    usage_guest_nice Float64,
    usage_user       Float64,
    usage_idle       Float64,
    usage_iowait     Float64
)
    engine = MergeTree PARTITION BY toYYYYMM(time) ORDER BY (time, host, cpu) SETTINGS index_granularity = 8192;

create table telegraf.disk
(
    time         DateTime,
    host         String,
    device       String,
    fstype       String,
    mode         String,
    path         String,
    inodes_used  Int64,
    total        Int64,
    free         Int64,
    used         Int64,
    used_percent Float64,
    inodes_total Int64,
    inodes_free  Int64
)
    engine = MergeTree PARTITION BY toYYYYMM(time) ORDER BY (time, host, device, fstype, mode, path) SETTINGS index_granularity = 8192;

create table telegraf.diskio
(
    time             DateTime,
    host             String,
    name             String,
    reads            Int64,
    read_time        Int64,
    write_bytes      Int64,
    write_time       Int64,
    io_time          Int64,
    weighted_io_time Int64,
    iops_in_progress Int64,
    writes           Int64,
    read_bytes       Int64
)
    engine = MergeTree PARTITION BY toYYYYMM(time) ORDER BY (time, host, name) SETTINGS index_granularity = 8192;

create table telegraf.kernel
(
    time             DateTime,
    host             String,
    interrupts       Int64,
    context_switches Int64,
    boot_time        Int64,
    processes_forked Int64,
    entropy_avail    Int64
)
    engine = MergeTree PARTITION BY toYYYYMM(time) ORDER BY (time, host) SETTINGS index_granularity = 8192;

create table telegraf.mem
(
    time              DateTime,
    host              String,
    free              Int64,
    committed_as      Int64,
    swap_cached       Int64,
    available         Int64,
    high_free         Int64,
    huge_pages_total  Int64,
    swap_total        Int64,
    write_back        Int64,
    used_percent      Float64,
    low_free          Int64,
    swap_free         Int64,
    vmalloc_total     Int64,
    buffered          Int64,
    commit_limit      Int64,
    huge_page_size    Int64,
    total             Int64,
    high_total        Int64,
    cached            Int64,
    active            Int64,
    wired             Int64,
    dirty             Int64,
    shared            Int64,
    used              Int64,
    huge_pages_free   Int64,
    low_total         Int64,
    mapped            Int64,
    vmalloc_used      Int64,
    write_back_tmp    Int64,
    available_percent Float64,
    slab              Int64,
    page_tables       Int64,
    vmalloc_chunk     Int64,
    inactive          Int64
)
    engine = MergeTree PARTITION BY toYYYYMM(time) ORDER BY (time, host) SETTINGS index_granularity = 8192;

create table telegraf.net
(
    time                  DateTime,
    host                  String,
    interface             String,
    err_in                Int64,
    err_out               Int64,
    drop_in               Int64,
    drop_out              Int64,
    bytes_sent            Int64,
    bytes_recv            Int64,
    packets_sent          Int64,
    packets_recv          Int64,
    tcp_rtomax            Int64,
    tcp_insegs            Int64,
    ip_reasmtimeout       Int64,
    icmp_outechoreps      Int64,
    icmp_inredirects      Int64,
    icmp_intimestampreps  Int64,
    icmpmsg_outtype0      Int64,
    tcp_currestab         Int64,
    udplite_indatagrams   Int64,
    ip_reasmoks           Int64,
    ip_outdiscards        Int64,
    ip_forwarding         Int64,
    icmp_inerrors         Int64,
    icmpmsg_outtype3      Int64,
    tcp_attemptfails      Int64,
    tcp_inerrs            Int64,
    udp_rcvbuferrors      Int64,
    ip_forwdatagrams      Int64,
    ip_reasmreqds         Int64,
    icmp_inmsgs           Int64,
    icmp_insrcquenchs     Int64,
    udp_outdatagrams      Int64,
    icmp_inaddrmaskreps   Int64,
    icmp_inparmprobs      Int64,
    icmp_outaddrmasks     Int64,
    tcp_maxconn           Int64,
    tcp_rtoalgorithm      Int64,
    udp_sndbuferrors      Int64,
    udp_indatagrams       Int64,
    udplite_outdatagrams  Int64,
    ip_inhdrerrors        Int64,
    icmp_outtimestamps    Int64,
    icmp_outredirects     Int64,
    tcp_retranssegs       Int64,
    tcp_estabresets       Int64,
    ip_inunknownprotos    Int64,
    ip_outrequests        Int64,
    icmp_outsrcquenchs    Int64,
    icmp_indestunreachs   Int64,
    tcp_passiveopens      Int64,
    udplite_inerrors      Int64,
    icmp_outerrors        Int64,
    icmp_outtimestampreps Int64,
    icmp_outechos         Int64,
    icmpmsg_intype3       Int64,
    udp_noports           Int64,
    udp_inerrors          Int64,
    udplite_incsumerrors  Int64,
    ip_reasmfails         Int64,
    ip_inreceives         Int64,
    icmp_inechoreps       Int64,
    icmp_intimestamps     Int64,
    tcp_outrsts           Int64,
    ip_indiscards         Int64,
    icmp_inaddrmasks      Int64,
    udp_incsumerrors      Int64,
    udplite_noports       Int64,
    ip_outnoroutes        Int64,
    ip_indelivers         Int64,
    ip_fragcreates        Int64,
    icmp_inechos          Int64,
    tcp_incsumerrors      Int64,
    tcp_activeopens       Int64,
    ip_defaultttl         Int64,
    ip_inaddrerrors       Int64,
    icmp_outparmprobs     Int64,
    icmp_intimeexcds      Int64,
    icmpmsg_intype8       Int64,
    udp_ignoredmulti      Int64,
    udplite_ignoredmulti  Int64,
    ip_fragoks            Int64,
    ip_fragfails          Int64,
    icmp_outaddrmaskreps  Int64,
    icmp_incsumerrors     Int64,
    icmp_outtimeexcds     Int64,
    tcp_rtomin            Int64,
    udplite_rcvbuferrors  Int64,
    icmp_outdestunreachs  Int64,
    icmp_outmsgs          Int64,
    tcp_outsegs           Int64,
    udplite_sndbuferrors  Int64
)
    engine = MergeTree PARTITION BY toYYYYMM(time) ORDER BY (time, host, interface) SETTINGS index_granularity = 8192;

create table telegraf.processes
(
    time          DateTime,
    host          String,
    zombies       Int64,
    running       Int64,
    unknown       Int64,
    dead          Int64,
    paging        Int64,
    blocked       Int64,
    stopped       Int64,
    sleeping      Int64,
    total         Int64,
    total_threads Int64,
    idle          Int64
)
    engine = MergeTree PARTITION BY toYYYYMM(time) ORDER BY (time, host) SETTINGS index_granularity = 8192;

create table telegraf.swap
(
    time         DateTime,
    host         String,
    in           Int64,
    out          Int64,
    total        Int64,
    used         Int64,
    free         Int64,
    used_percent Float64
)
    engine = MergeTree PARTITION BY toYYYYMM(time) ORDER BY (time, host) SETTINGS index_granularity = 8192;

create table telegraf.system
(
    time    DateTime,
    host    String,
    uptime  Int64,
    load1   Float64,
    load5   Float64,
    load15  Float64,
    n_cpus  Int64,
    n_users Int64
)
    engine = MergeTree PARTITION BY toYYYYMM(time) ORDER BY (time, host) SETTINGS index_granularity = 8192;
