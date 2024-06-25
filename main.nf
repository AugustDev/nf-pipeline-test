params.s3_paths = []

if (params.s3_paths.size() == 0) {
    error "Please provide S3 paths using --s3_paths option. For example: --s3_paths 's3://bucket/file1.txt,s3://bucket/file2.txt'"
}

process processS3FileAndPrintSize {
    input:
    path s3_file

    output:
    stdout

    script:
    """
    file_size=\$(ls -lh $s3_file | awk '{print \$5}')
    echo "File $s3_file has size: \$file_size"
    """
}

workflow {
    Channel
        .fromList(params.s3_paths.tokenize(','))
        .map { it -> file(it) }
        .set { s3_file_channel }

    processS3FileAndPrintSize(s3_file_channel)
        .view()
}