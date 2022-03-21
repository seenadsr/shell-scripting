
#spot instance removal
SPOT_EC2=$(aws ec2 describe-instances --filters Name=instance-lifecycle,Values=spot --query Reservations[*].Instances[*].[InstanceId] --output text)
SPOT_REQ=$(aws ec2 describe-instances --filters Name=instance-lifecycle,Values=spot --query Reservations[*].Instances[*].[SpotInstanceRequestId] --output text)

echo ${SPOT_EC2}
if [ $? -eq 0 ]
   aws ec2 terminate-instances --instance-ids ${SPOT-EC2}
 echo ${SPOT_REQ}
 if [ $? -eq 0 ];then
    aws ec2 cancel-spot-instance-requests --spot-instance-request-ids ${SPOT_REQ}
fi
fi
