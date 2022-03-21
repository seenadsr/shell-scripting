set -x
if [ -z "$1" ];then
  echo " Instance name need to be specified"
  exit 1
fi

 COMPONENT=$1

#spot instance removal
SPOT_EC2=$(aws ec2 describe-instances --filters Name=instance-lifecycle,Values=spot --query Reservations[*].Instances[*].[InstanceId] --output text)
SPOT_REQ=$(aws ec2 describe-instances --filters Name=instance-lifecycle,Values=spot --query Reservations[*].Instances[*].[SpotInstanceRequestId] --output text)

if [ "$1 == "del" ];then
   for terminate in ${SPOT_EC2}; do
   COMPONENT=$terminate
   aws ec2 terminate-instances --instance-ids ${COMPONENT}
done
fi

