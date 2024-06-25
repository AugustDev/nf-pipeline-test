params.s3_paths = []

if (params.s3_paths.size() == 0) {
    error "Please provide S3 paths using --s3_paths option. For example: --s3_paths 's3://bucket/file1.txt,s3://bucket/file2.txt'"
}

process processS3FileAndPrintSize {
    input:
    path s3_file

    output:
    path 'file_info.txt'

    script:
    """
    echo "Processing file: ${s3_file}" > file_info.txt
    if [ -e "${s3_file}" ]; then
        echo "File exists: ${s3_file}" >> file_info.txt
        ls -lhL "${s3_file}" >> file_info.txt
        cat file_info.txt
    else
        echo "File not found: ${s3_file}" >> file_info.txt
    fi
    """
}

workflow {
    Channel
        .fromList(params.s3_paths.tokenize(','))
        .map { it -> file(it) }
        .set { s3_file_channel }

    processS3FileAndPrintSize(s3_file_channel)
        .flatten()
        .view { file_info ->
            println file_info.text
        }
}
