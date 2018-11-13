# Get the json file
aws s3api get-bucket-lifecycle-configuration --bucket raidevolution.actualit.info
# Puts json file
aws s3api put-bucket-lifecycle-configuration --bucket raidevolution.actualit.info --lifecycle-configuration file://config.json
