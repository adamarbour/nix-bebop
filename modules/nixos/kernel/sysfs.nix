{
  boot.kernel.sysfs = {
    # enable transparent hugepages with deferred defragmentation
    kernel.mm.transparent_hugepage = {
      enable = "always";
      defrag = "defer";
      shmem_enabled = "within_size";
    };
  };
}
