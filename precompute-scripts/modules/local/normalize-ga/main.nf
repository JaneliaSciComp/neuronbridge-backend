include {
    area_to_alignment_space;
    get_lib_arg;
} from '../../../nfutils/utils'

process NORMALIZE_GA {
    container { task.ext.container ?: 'ghcr.io/janeliascicomp/colormipsearch-tools:3.1.0' }
    cpus { cpus }
    memory "${mem_gb} GB"
    label 'neuronbridgeTools'

    input:
    tuple val(job_id),
          val(anatomical_area),
          val(masks_library),
          val(masks_offset),
          val(masks_length),
          val(targets_library)
    tuple path(app_jar),
          path(log_config),
          val(app_runner)
    path(db_config_file)
    val(cpus)
    val(mem_gb)
    val(java_opts)
    tuple val(normalize_ga_processing_tag),
          val(masks_published_names),
          val(targets_published_names),
          val(processing_size)

    script:
    def java_app = app_jar ?: '/app/colormipsearch-3.1.0-jar-with-dependencies.jar'
    def log_config_arg = log_config ? "-Dlog4j.configurationFile=file:${log_config}" : ''
    def java_mem_opts = "-Xmx${mem_gb-1}G -Xms${mem_gb-1}G"
    def concurrency_arg = cpus ? "--task-concurrency ${2 * cpus -1}" : ''
    def alignment_space = area_to_alignment_space(anatomical_area)
    def masks_arg = get_lib_arg(masks_library, masks_offset, masks_length)
    def masks_published_names_arg = masks_published_names ? "--masks-published-names ${masks_published_names}" : ''
    def targets_library_arg = targets_library ? "--targets-libraries ${targets_library}" : ''
    def targets_published_names_arg = targets_published_names ? "--targets-published-names ${targets_published_names}" : ''

    """
    echo "\$(date) Run normalize-score job: ${job_id} on \$(hostname -s)"
    ${app_runner} java \
        ${java_opts} ${java_mem_opts} \
        ${log_config_arg} \
        -jar ${app_jar} \
        mormalizeGradientScores \
        --config ${db_config_file} \
        ${concurrency_arg} \
        -as ${alignment_space} \
        --masks-libraries ${masks_arg} \
        ${masks_published_names_arg} \
        ${targets_library_arg} \
        ${targets_published_names_arg} \
        --processing-tag ${normalize_ga_processing_tag} \
    """
}
