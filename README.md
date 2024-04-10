# Deploy Serverless Defender as a Lambda Layer using Terraform.

**Description:**

This Terraform template provides an AWS Lambda function along with a Lambda layer, configured to run Prisma Cloud Serverless Defender.

**General Information:**

Prisma Cloud Serverless Defenders protect serverless functions at runtime. Currently, Prisma Cloud supports AWS Lambda functions.

Lambda layers are ZIP archives that contain libraries, custom runtimes, or other dependencies. Layers let you add reusable components to your functions, and focus deployment packages on business logic. They are extracted to the /opt directory in the function execution environment. For more information, see the AWS Lambda layers documentation.

Prisma Cloud delivers Serverless Defender as a Lambda layer. Deploy Serverless Defender to your function by wrapping the handler and setting an environment variable.

**Download the Serverless Defender layer from Compute Console:**

Open Console, then go to **Manage > Defenders > Deploy> Defenders > Single Defender.**
Choose the DNS name or IP address that Serverless Defender uses to connect to Console.
Set the **Defender type** to **Serverless Defender**.
Select a **runtime**.
Prisma Cloud supports Lambda layers for Node.js, Python, Ruby, C#, and Java. For Deployment Type, select Layer.
Download the Serverless Defender layer. A ZIP file is downloaded to your host.

**Define your Runtime Protection Policy**

By default, Prisma Cloud ships with an empty serverless runtime policy. An empty policy disables runtime defense entirely.

You can enable runtime defense by creating a rule. By default, new rules:

Apply to all functions (*), but you can target them to specific functions by function name.
Block all processes from running except the main process. This protects against command injection attacks.
When functions are invoked, they connect to Compute Console and retrieve the latest policy. To ensure that functions start executing at time=0 with your custom policy, you must predefine the policy. Predefined policy is embedded into your function along with the Serverless Defender by way of the TW_POLICY environment variable.
Log into Prisma Cloud Console.
Go to Defend > Runtime > Serverless Policy.
Click Add rule.
In the General tab, enter a rule name.
(Optional) Target the rule to specific functions.
Set the rule parameters in the Processes, Networking, and File System tabs.
Click Save.
Define your Serverless WAAS Policy
Prisma Cloud lets you protect your serverless functions against application layer attacks by utilizing the serverless Web Application and API Security (WAAS).
By default, the serverless WAAS is disabled. To enable it, add a new serverless WAAS rule.
Log into Prisma Cloud Console.
Go to Defend > WAAS > Serverless.
Click Add rule.
In the General tab, enter a rule name.
(Optional) Target the rule to specific functions.
Set the protections you want to apply (SQLi, CMDi, Code injection, XSS, LFI).
Click Save.
Deploy the Prisma Cloud Serverless defender as a Lambda layer using Terraform:
Embed the Serverless Defender as a layer, and run it when your function is invoked. If you are using a deployment framework such as SAM or Serverless Framework you can reference the layer from within the configuration file.
Prerequisites:
You already have a Lambda function terraform template.
Your Lambda function is written for Node.js, Python, or Ruby.
Your function’s execution role grants it permission to write to CloudWatch Logs. Note that the AWSLambdaBasicExecutionRole grants permission to write to CloudWatch Logs.


Provide your credentials in the provider section. 
Set file name to the twistlock_defender_layer.zip file in the filename, and the function runtime.
Now you need to edit your function deployment with the following settings:
handler         = "twistlock.handler" # Set the handler to twistlock.handler
Environmental variables:
environment {
    variables = {
      TW_POLICY       = "" # In Compute Console, go to Manage > Defenders > Deploy > Single Defender. Defender type, select Serverless. In Set the Twistlock environment variable, enter the function name and region. Copy the generated Value.
      ORIGINAL_HANDLER = "lambda_function.lambda_handler"
    }
  }





