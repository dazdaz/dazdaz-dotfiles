#!/bin/bash

# Tue Apr 10 12:17:50 +08 2018

AWS_JSON_PRICE_URL=https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/index.json
AWS_JSON_PRICE_OFFERS_URL=https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/index.json
OUTPUTDIR_PRICE=aws_pricing_`date +%d-%m-%Y`
OUTPUTDIR_PRICEOFFERS=aws_pricing_offer_`date +%d-%m-%Y`

mkdir -p ~/scripts/$OUTPUTDIR_PRICE
cd ~/scripts/$OUTPUTDIR_PRICE

# Obtain URI's for Prices, stored in CSV and then download them into current directory
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
# Obtain URI's for Prices, stored in CSV and then download them into current directory
for i in `wget -q -O- $AWS_JSON_PRICE_OFFERS_URL |  jq -r '.offers[] ' | grep current | cut -d'"' -f4`
   do
   FILENAME_JSON=`echo $i | awk -F/ '{sub(/%$/,"",$5); print $5 "_" $7}'`
   echo $FILENAME_JSON
   wget https://pricing.us-east-1.amazonaws.com$i -O $FILENAME_JSON
done
