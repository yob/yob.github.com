---
layout: post
title: "AWS Cost Usage Reports 2.0 in Athena"
---

Cost Usage Reports (CUR) are detailed line-item exports of AWS
usage. The underlying data matches what's available in the AWS
Cost Explorer, but exported to an S3 bucket where it can be fed into
custom reporting and analysis. [In 2023 AWS announced CUR v2.0](https://aws.amazon.com/about-aws/whats-new/2023/11/aws-billing-cost-management-data-exports/)
with new features and a new stable schema with up to 125 columns.

For serious analysis and reporting the common setup is parquet files written
to an S3 bucket, partitioned by month using [hive
partitioning](https://athena.guide/articles/hive-style-partitioning).
Businesses that have a data platform are then likely to ship the data off
to Snowflake/Redshift/BigQuery/Databricks, and expose it in a visualization tool
of choice.

However, parquet files in a hive partitioned S3 bucket can also be queried using
Athena with the AWS console. It's not pretty, but no extra tooling is required
and for quick dives into the raw data it can be useful.

To make the data available to Athena as a table, [AWS docs for CUR 2.0](https://docs.aws.amazon.com/cur/latest/userguide/dataexports-processing.html)
recommend either installing a Cloudformation stack or running a glue crawler
over the S3 bucket. I don't like either of those - what if I just want to
create a table manually or via a tool like terraform? I found remarkably little
info on the Internet about this, so I ran the glue crawler on some test data and
then worked back to a plain `CREATE TABLE` statement that uses [partition projection](https://docs.aws.amazon.com/athena/latest/ug/partition-projection.html)
to make new months available to query as data appears in the bucket.

This assumes the CUR 2.0 data export was creatde with the following details:

* Type: CUR 2.0
* Include resource IDs (you want this - cost explorer only supports grouping by resource ID over the past 14 days, you can use this data to query resource costs over months and years)
* Time granularity: hourly
* Compression: parquet
* File versioning: Overwrite existing data export file

{% highlight sql %}
CREATE EXTERNAL TABLE `cur_projected`(
  `bill_bill_type` string, 
  `bill_billing_entity` string, 
  `bill_billing_period_end_date` timestamp, 
  `bill_billing_period_start_date` timestamp, 
  `bill_invoice_id` string, 
  `bill_invoicing_entity` string, 
  `bill_payer_account_id` string, 
  `bill_payer_account_name` string, 
  `cost_category` map<string,string>, 
  `discount` map<string,double>, 
  `discount_bundled_discount` double, 
  `discount_total_discount` double, 
  `identity_line_item_id` string, 
  `identity_time_interval` string, 
  `line_item_availability_zone` string, 
  `line_item_blended_cost` double, 
  `line_item_blended_rate` string, 
  `line_item_currency_code` string, 
  `line_item_legal_entity` string, 
  `line_item_line_item_description` string, 
  `line_item_line_item_type` string, 
  `line_item_net_unblended_cost` double, 
  `line_item_net_unblended_rate` string, 
  `line_item_normalization_factor` double, 
  `line_item_normalized_usage_amount` double, 
  `line_item_operation` string, 
  `line_item_product_code` string, 
  `line_item_resource_id` string, 
  `line_item_tax_type` string, 
  `line_item_unblended_cost` double, 
  `line_item_unblended_rate` string, 
  `line_item_usage_account_id` string, 
  `line_item_usage_account_name` string, 
  `line_item_usage_amount` double, 
  `line_item_usage_end_date` timestamp, 
  `line_item_usage_start_date` timestamp, 
  `line_item_usage_type` string, 
  `pricing_currency` string, 
  `pricing_lease_contract_length` string, 
  `pricing_offering_class` string, 
  `pricing_public_on_demand_cost` double, 
  `pricing_public_on_demand_rate` string, 
  `pricing_purchase_option` string, 
  `pricing_rate_code` string, 
  `pricing_rate_id` string, 
  `pricing_term` string, 
  `pricing_unit` string, 
  `product` map<string,string>, 
  `product_comment` string, 
  `product_fee_code` string, 
  `product_fee_description` string, 
  `product_from_location` string, 
  `product_from_location_type` string, 
  `product_from_region_code` string, 
  `product_instance_family` string, 
  `product_instance_type` string, 
  `product_instancesku` string, 
  `product_location` string, 
  `product_location_type` string, 
  `product_operation` string, 
  `product_pricing_unit` string, 
  `product_product_family` string, 
  `product_region_code` string, 
  `product_servicecode` string, 
  `product_sku` string, 
  `product_to_location` string, 
  `product_to_location_type` string, 
  `product_to_region_code` string, 
  `product_usagetype` string, 
  `reservation_amortized_upfront_cost_for_usage` double, 
  `reservation_amortized_upfront_fee_for_billing_period` double, 
  `reservation_availability_zone` string, 
  `reservation_effective_cost` double, 
  `reservation_end_time` string, 
  `reservation_modification_status` string, 
  `reservation_net_amortized_upfront_cost_for_usage` double, 
  `reservation_net_amortized_upfront_fee_for_billing_period` double, 
  `reservation_net_effective_cost` double, 
  `reservation_net_recurring_fee_for_usage` double, 
  `reservation_net_unused_amortized_upfront_fee_for_billing_period` double, 
  `reservation_net_unused_recurring_fee` double, 
  `reservation_net_upfront_value` double, 
  `reservation_normalized_units_per_reservation` string, 
  `reservation_number_of_reservations` string, 
  `reservation_recurring_fee_for_usage` double, 
  `reservation_reservation_a_r_n` string, 
  `reservation_start_time` string, 
  `reservation_subscription_id` string, 
  `reservation_total_reserved_normalized_units` string, 
  `reservation_total_reserved_units` string, 
  `reservation_units_per_reservation` string, 
  `reservation_unused_amortized_upfront_fee_for_billing_period` double, 
  `reservation_unused_normalized_unit_quantity` double, 
  `reservation_unused_quantity` double, 
  `reservation_unused_recurring_fee` double, 
  `reservation_upfront_value` double, 
  `resource_tags` map<string,string>, 
  `savings_plan_amortized_upfront_commitment_for_billing_period` double, 
  `savings_plan_end_time` string, 
  `savings_plan_instance_type_family` string, 
  `savings_plan_net_amortized_upfront_commitment_for_billing_period` double, 
  `savings_plan_net_recurring_commitment_for_billing_period` double, 
  `savings_plan_net_savings_plan_effective_cost` double, 
  `savings_plan_offering_type` string, 
  `savings_plan_payment_option` string, 
  `savings_plan_purchase_term` string, 
  `savings_plan_recurring_commitment_for_billing_period` double, 
  `savings_plan_region` string, 
  `savings_plan_savings_plan_a_r_n` string, 
  `savings_plan_savings_plan_effective_cost` double, 
  `savings_plan_savings_plan_rate` double, 
  `savings_plan_start_time` string, 
  `savings_plan_total_commitment_to_date` double, 
  `savings_plan_used_commitment` double)
PARTITIONED BY (
  `billing_period` string COMMENT "format: YYYY-MM")
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  's3://<bucket-name>/prefix/'
TBLPROPERTIES (
  'projection.enabled'='true', 
  'projection.billing_period.type'='date', 
  'projection.billing_period.range'='2025-01,2030-12', 
  'projection.billing_period.format'='yyyy-MM', 
  'projection.billing_period.interval'='1',
  'projection.billing_period.interval.unit'='MONTHS', 
  'storage.location.template'='s3://<bucket-name>/prefix/CostUsageReport/data/BILLING_PERIOD=${billing_period}', 
  'transient_lastDdlTime'='1745244785'
)
{% endhighlight %}

Here's a couple of sample queries to test the table is working. First, a count of line items
per month since the start of 2025:

{% highlight sql %}
SELECT bill_billing_period_start_date, count(*)
FROM "default"."cur_projected"
WHERE billing_period >= '2025-01'
GROUP BY 1
ORDER BY 1
{% endhighlight %}

A sum of costs per calendar month (across all invoices):

{% highlight sql %}
SELECT bill_billing_period_start_date, sum(line_item_unblended_cost)
FROM "default"."cur_projected"
WHERE billing_period >= '2025-01'
GROUP BY 1
ORDER BY 1
{% endhighlight %}

A sum of costs for the current month, grouped by the value of cost allocation
tag `department`:

{% highlight sql %}
SELECT resource_tags['user_department'] as tag_department, sum(line_item_unblended_cost) as cost
FROM "default"."cur_projected"
WHERE billing_period = date_format(current_timestamp, '%Y-%m')
GROUP BY 1
ORDER BY 2 desc
{% endhighlight %}

All columns for a sample of rows in the current month:

{% highlight sql %}
SELECT *
FROM "default"."cur_projected"
WHERE billing_period = date_format(current_timestamp, '%Y-%m')
LIMIT 100
{% endhighlight %}

A final tip. A newly created CUR 2.0 Data Export will start exporting data
for the current billing month. It's not described clearly in the AWS docs, but
once the export is created and working it's possible to have up to 36 months (3
years) of data backfilled by opening a support ticket in the same account. I've
had successful backfills via a ticket with the following details:

* Subject: Backfill of Cost Usage Report Export
* Case type: Account and Billing
* Service: Account
* Category: Other Account Issues
