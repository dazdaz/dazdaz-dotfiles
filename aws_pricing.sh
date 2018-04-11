#!/bin/bash

# Tue Apr 10 12:17:50 +08 2018

AWS_JSON_PRICE_URL=https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/index.json
AWS_JSON_PRICE_OFFERS_URL=https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/index.json
OUTPUTDIR_PRICE=aws_pricing_`date +%d-%m-%Y`
OUTPUTDIR_PRICEOFFERS=aws_pricing_offer_`date +%d-%m-%Y`

mkdir -p ~/scripts/$OUTPUTDIR_PRICE
cd ~/scripts/$OUTPUTDIR_PRICE

# Obtain URI's for Prices and then download them into current directory
for i in `wget -q -O- $AWS_JSON_PRICE_URL |  jq -r '.offers[] ' | grep current | cut -d'"' -f4`
 do
   FILENAME_JSON=`echo $i | awk -F/ '{sub(/%$/,"",$5); print $5 "_" $7}'`
  # echo
  # echo "i: $i"
  # echo $FILENAME_JSON
  # echo "FULL URL: https://pricing.us-east-1.amazonaws.com$i"
   wget https://pricing.us-east-1.amazonaws.com$i -O $FILENAME_JSON
done


echo "Now Downloading AWS Pricing Offers ..."
mkdir -p ~/scripts/$OUTPUTDIR_PRICEOFFERS
cd ~/scripts/$OUTPUTDIR_PRICEOFFERS

# Offers = Discounts ?
# Obtain URI's for Prices then download them into current directory
for i in `wget -q -O- $AWS_JSON_PRICE_OFFERS_URL |  jq -r '.offers[] ' | grep current | cut -d'"' -f4`
   do
   FILENAME_JSON=`echo $i | awk -F/ '{sub(/%$/,"",$5); print $5 "_" $7}'`
   echo $FILENAME_JSON
   wget https://pricing.us-east-1.amazonaws.com$i -O $FILENAME_JSON
done


#"AWS GovCloud (US)",
#"Asia Pacific (Mumbai)",
#"Asia Pacific (Osaka-Local)",
#"Asia Pacific (Seoul)",
#"Asia Pacific (Singapore)",
#"Asia Pacific (Sydney)",
#"Asia Pacific (Tokyo)",
#"Canada (Central)",
#"EU (Frankfurt)",
#"EU (Ireland)",
#"EU (London)",
#"EU (Paris)",
#"South America (Sao Paulo)",
#"US East (N. Virginia)",
#"US East (Ohio)",
#"US West (N. California)",
#"US West (Oregon)",

# View EC2 instance type, with a Linux VM in Singapore on a shared tenancy
cat aws_pricing_10-04-2018/AmazonEC2_index.json | jq '[.products| to_entries | .[].value | select (.attributes.operatingSystem == "Linux" and .attributes.location=="Asia Pacific (Singapore)" and .attributes.tenancy == "Shared")  | {key: .sku, value: .}]|from_entries'

# View the pricing in USD per hour for EC2 instance type
cat aws_pricing_10-04-2018/AmazonEC2_index.json | jq '.terms.OnDemand | .. | .priceDimensions? | select (. != null) |map_values (.)| map (. + {sku: .rateCode|split(".")[0]}) | .[]'

# Show EC2 Instance Types in Singapore with a shared tenancy type
curl -s  https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonEC2/current/index.json | jq -r '.products[].attributes | select(.location == "Asia Pacific (Singapore)" and .tenancy == "Shared" ) | .instanceType' | sort -u
