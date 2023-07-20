resource "aws_cloudformation_stack" "books_uploader" {
  name = "BooksUploader"

  template_body = jsonencode({
    "Resources" : {
      "BooksUploader" : {
        "Type" : "Custom::CustomResource",
        "Properties" : {
          "ServiceToken" : "${aws_lambda_function.FunctionUploadBooks.arn}",
          "ParameterOne" : "Parameter to pass into Custom Lambda Function"
        }
      }
    }
  })

  depends_on = [
    aws_lambda_function.FunctionUploadBooks,
    aws_elasticsearch_domain.OpenSearchServiceDomain,
    aws_lambda_function.UpdateSearchCluster
  ]
}


########################## ES Role Creator Lambda function Trigger using this cloudformation #################################

resource "aws_cloudformation_stack" "es_role_creator" {
  name = "ESRoleCreator"

  template_body = jsonencode({
    "Resources" : {
      "ESRoleCreator" : {
        "Type" : "Custom::CustomResource",
        "Properties" : {
          "ServiceToken" : "${aws_lambda_function.CreateOSRoleFunction.arn}",
          "ParameterOne" : "Parameter to pass into Custom Lambda Function"
        }
      }
    }

  })
  depends_on = [
    aws_lambda_function.CreateOSRoleFunction
  ]
}

################## repoupdate Lambda function Trigger using this cloudformation


# resource "aws_cloudformation_stack" "repository_updater" {
#   name = "RepositoryUpdater"

#   template_body = jsonencode ({
#     "Resources" : {
#       "RepositoryUpdater" : {
#         "Type" : "Custom::CustomResource",
#         "Properties" : {
#           "ServiceToken" : "${aws_lambda_function.UpdateConfigFunction.arn}"
#           "ParameterOne" : "Parameter to pass into Custom Lambda Function"
#         }
#       }
#     }
#   })

#   depends_on = [
#     aws_lambda_function.UpdateConfigFunction
#   ]
# }


##################### BucketCleanUp Function trigger using this cloudformation ####################

# resource "aws_cloudformation_stack" "delete_buckets_objects" {
#   name = "DeleteBucketsObjects"

#   template_body = jsonencode({
#     "Resources" : {
#       "DeleteBucketsObjects" : {
#         "Type" : "Custom::CustomResource",
#         "Properties" : {
#           "ServiceToken" : "${aws_lambda_function.BucketCleanup.arn}",
#           # "BucketNames" : ["${aws_s3_bucket.S3Bucket.bucket}","${aws_s3_bucket.S3Bucket2.bucket}"]
#         }
#       }
#     }
#   })

#   depends_on = [
#     aws_s3_bucket.S3Bucket,
#     aws_s3_bucket.S3Bucket2
#   ]


# }
