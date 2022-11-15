terraform {
  required_version = "1.2.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.18.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  #Not Recommended
  #access_key =
  ##secret_key = 
  profile = var.aws_profile
}

resource "aws_codepipeline" "this" {
  name     = "my-pipeline-teste"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    #s3 ou custom
    type = "S3"

  }

  stage {
    name = "Source"

    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      #CodeCommit, ECR, S3, Github
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output_edjonathan"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.this.arn
        FullRepositoryId = "my-organization/example"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name     = "Build"
      category = "Build"
      owner    = "AWS"
      #Codebuild, jenkins, cloudbees, teamcity
      provider         = "CodeBuild"
      input_artifacts  = ["source_output_edjonathan"]
      output_artifacts = ["build_output_edjonathan"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build_application.name
      }
    }
  }

  stage {
    name = "Test"

    action {
      name     = "Test"
      category = "Test"
      owner    = "AWS"
      #Codebuild, AWS Device Farm, 3rd party tools
      provider         = "CodeBuild"
      input_artifacts  = ["source_output_edjonathan"]
      output_artifacts = ["build_test_output_edjonathan"]
      version          = "1"

      configuration = {
        ProjectName = "test"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name     = "Deploy"
      category = "Deploy"
      owner    = "AWS"
      #CodeDeploy, Cloudformation, Elastic Beanstalk, ECS, S3...
      provider        = "CloudFormation"
      input_artifacts = ["build_output_edjonathan", "build_test_output_edjonathan"]
      version         = "1"

      configuration = {
        ActionMode     = "REPLACE_ON_FAILURE"
        Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
        OutputFileName = "CreateStackOutput.json"
        StackName      = "MyStack"
        TemplatePath   = "build_output::sam-templated.yaml"
      }
    }
  }
}