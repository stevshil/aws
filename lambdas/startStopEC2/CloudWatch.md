# Set up lambda for Cloudwatch trigger

* Select Events - Rules
* Create Rule
* Event Source
  * Schedule
  * Cron Expression
    * 0 8 \? \* MON-FRI \*
* Targets
  * Lambda function
  * Function: [Start|Stop]EC2Academy
  * Constant (JSON text): { "REGION": "us-west-1", "INSTANCES": ["i-02441efc1d84fc00a", "i-03ada82648c05ef1f", "i-0cff6aec86d816ddd", "i-04ad80a3639f0b833"]}
* Configure Details
  * Name: [Start|Stop]AcademyEC2
  * Description: [Start|Stop] AL Academy EC2 Instances
  * State: Enabled
