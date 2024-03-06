process GA {
    cpus { ga_cpus }
    memory "${ga_mem_gb} GB"
    clusterOptions { task.ext.cluster_opts }


    input:
    tuple val(anatomical_area),
          val(masks_library),
          val(targets_library)
    tuple path(app_jar), val(cds_runner)
    path(db_config_file)
    val(ga_cpus)
    val(ga_mem_gb)
    val(java_opts)

    script:
    """
    java -jar ${app_jar}
    """
}
