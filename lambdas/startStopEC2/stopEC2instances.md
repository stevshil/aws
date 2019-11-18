# Web UI details

* Layers: Cloudwatch Events, Amazon Cloudwatch Logs, Amazon EC2
* Runtime: Python 3.7
* Handler: lambda_function.lambda_handler
* Tags: Name/Owner
* Execution role: Use existing - lambda_startstopec2
* Basic Settings:
  * Description: Stop EC2 Academy Instances
  * Memory: 128MB
  * Timeout: 10 sec

