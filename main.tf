provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "eu-west-3" # Change to your desired AWS region
}

resource "aws_lambda_layer_version" "example" {
  filename            = "./twistlock_defender_layer.zip" # Path to the zip file
  layer_name          = "twistlock"
  compatible_runtimes = ["python3.8"] # Specify the compatible runtimes for your layer
}

resource "aws_lambda_function" "example" {
  filename         = "./lambda_function_payload.zip" # Path to the Lambda function code ZIP file
  function_name    = "example_lambda_function"
  role            = aws_iam_role.example_role.arn # Provide the ARN of the IAM role
  runtime         = "python3.8" 
  handler         = "twistlock.handler" # Set the handler to twistlock.handler

  environment {
    variables = {
      TW_POLICY       = "" # In Compute Console, go to Manage > Defenders > Deploy > Single Defender. Defender type, select Serverless. In Set the Twistlock environment variable, enter the function name and region. Copy the generated Value.
      ORIGINAL_HANDLER = "lambda_function.lambda_handler"
    }
  }

  layers = [aws_lambda_layer_version.example.arn] # Add the twistlock layer to this Lambda function
}

