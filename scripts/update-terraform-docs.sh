TERRAFORM_DOCS_VERSION=0.10.0-rc.1
TERRAFORM_MODULES_PATH=src/terraform/modules

for d in $(ls -1 $TERRAFORM_MODULES_PATH);
do

docker run \
    -v $(pwd)/$TERRAFORM_MODULES_PATH/$d:/module \
    quay.io/terraform-docs/terraform-docs:$TERRAFORM_DOCS_VERSION markdown document /module > $TERRAFORM_MODULES_PATH/$d/README.md

if [ $? -eq 0 ] ; then
    git add "./$TERRAFORM_MODULES_PATH/$d/README.md"
fi
done