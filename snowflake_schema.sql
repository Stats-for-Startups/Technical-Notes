CREATE  TABLE "public".company_lookup (
	company_uuid         uuid  NOT NULL ,
	streak_charge_uuid   uuid  NOT NULL ,
	cb_org_uuid          uuid   ,
	revenue_model        text   ,
	secondary_revenue_model text   ,
	customer_acquisition_channel text   ,
	secondary_customer_acquisition_channel text   ,
	tam_uuid             uuid   ,
	sam_uuid             uuid   ,
	som_uuid             uuid   ,
	CONSTRAINT pk_company_lookup_company_uuid PRIMARY KEY ( company_uuid ),
	CONSTRAINT unq_company_lookup_sam_uuid UNIQUE ( sam_uuid ) ,
	CONSTRAINT unq_company_lookup_som_uuid UNIQUE ( som_uuid ) ,
	CONSTRAINT unq_company_lookup_tam_uuid UNIQUE ( tam_uuid )
 );

COMMENT ON TABLE "public".company_lookup IS 'This table reps=resents the Company hierarchy in the Charge Ventures database';

COMMENT ON COLUMN "public".company_lookup.streak_charge_uuid IS 'links to the streak st_newcos row in the database';

CREATE  TABLE "public".market_lookup (
	company_uuid         uuid  NOT NULL ,
	industry             text
 );

COMMENT ON TABLE "public".market_lookup IS '"flat" file containing all the market designations for a given company. the industries are specified per the crunchbase schema';

ALTER TABLE "public".market_lookup ADD CONSTRAINT company_uuid FOREIGN KEY ( company_uuid ) REFERENCES "public".company_lookup( company_uuid );


CREATE  TABLE "public".market_size (
	market_size_uuid     uuid  NOT NULL ,
	company_uuid         uuid  NOT NULL ,
	tam_uuid             uuid   ,
	sam_uuid             uuid   ,
	som_uuid             uuid   ,
	CONSTRAINT pk_market_size_market_size_uuid PRIMARY KEY ( market_size_uuid ),
	CONSTRAINT unq_market_size_tam_uuid UNIQUE ( tam_uuid ) ,
	CONSTRAINT unq_market_size_som_uuid UNIQUE ( som_uuid ) ,
	CONSTRAINT unq_market_size_sam_uuid UNIQUE ( sam_uuid )
 );

ALTER TABLE "public".market_size ADD CONSTRAINT fk_market_size_company_lookup FOREIGN KEY ( company_uuid ) REFERENCES "public".company_lookup( company_uuid );

CREATE  TABLE "public".tam (
	tam_uuid             uuid  NOT NULL ,
	tam_value            float8  NOT NULL ,
	tam_scenario         text  NOT NULL ,
	tam_currency         char(3)  NOT NULL ,
	tam_date             date  NOT NULL ,
	tam_date_precision   text  NOT NULL ,
	tam_geography        text   ,
	tam_source           text   ,
	tam_source_date      text   ,
	tam_past_growth_rate_yearly integer   ,
	tam_future_growth_rate_yearly integer   ,
	CONSTRAINT pk_tam_tam_uuid PRIMARY KEY ( tam_uuid )
 );

COMMENT ON TABLE "public".tam IS 'Total Addressable Market (TAM): The total market demand for a product or service. It’s the maximum amount of revenue a business can possibly generate by selling their product or service in a specific market.';

ALTER TABLE "public".tam ADD CONSTRAINT fk_tam_market_size FOREIGN KEY ( tam_uuid ) REFERENCES "public".market_size( tam_uuid );

CREATE  TABLE "public".sam (
	sam_uuid             uuid  NOT NULL ,
	sam_value            float8  NOT NULL ,
	sam_scenario         text  NOT NULL ,
	sam_currency         char(3)  NOT NULL ,
	sam_date             date  NOT NULL ,
	sam_date_precision   text  NOT NULL ,
	sam_geography        text   ,
	sam_source           text   ,
	sam_source_date      text   ,
	sam_past_growth_rate_yearly integer   ,
	sam_future_growth_rate_yearly integer   ,
	CONSTRAINT pk_sam_sam_uuid PRIMARY KEY ( sam_uuid )
 );

COMMENT ON TABLE "public".sam IS 'Serviceable Addressable Market (SAM): The segment of the TAM targeted by your products and services which is within your geographical reach.';

ALTER TABLE "public".sam ADD CONSTRAINT sam FOREIGN KEY ( sam_uuid ) REFERENCES "public".market_size( sam_uuid );

CREATE  TABLE "public".som (
	som_uuid             uuid  NOT NULL ,
	som_value            float8  NOT NULL ,
	som_scenario         text  NOT NULL ,
	som_currency         char(3)  NOT NULL ,
	som_date             date  NOT NULL ,
	som_date_precision   text  NOT NULL ,
	som_geography        text   ,
	som_source           text   ,
	som_source_date      text   ,
	som_past_growth_rate_yearly integer   ,
	som_future_growth_rate_yearly integer   ,
	CONSTRAINT pk_som_som_uuid PRIMARY KEY ( som_uuid )
 );

COMMENT ON TABLE "public".som IS 'Share of Market (SOM): The size of your actual customer base or the realistic percentage of your serviceable addressable market that you can capture. This figure can help you predict the amount of revenue you can actually generate within your market.';

ALTER TABLE "public".som ADD CONSTRAINT som FOREIGN KEY ( som_uuid ) REFERENCES "public".market_size( som_uuid );

CREATE  TABLE "public".info_event_lookup (
	info_event_uuid      uuid  NOT NULL ,
	cb_round_uuid        uuid   ,
	user_revenue         text   ,
	product_stage        text   ,
	deck_attributes_uuid uuid   ,
	company_uuid         uuid   ,
	h_revenue_uuid       uuid   ,
	f_revenue_uuid       uuid   ,
	gross_margin_uuid    uuid   ,
	burn_rate_uuid       uuid   ,
	ask_uuid             uuid   ,
	pre_m_uuid           uuid   ,
	cac_uuid             uuid   ,
	aov_uuid             uuid   ,
	ltv_uuid             uuid   ,
	CONSTRAINT pk_info_event_lookup_info_event_uuid PRIMARY KEY ( info_event_uuid ),
	CONSTRAINT unq_info_event_lookup_aov_uuid UNIQUE ( aov_uuid ) ,
	CONSTRAINT unq_info_event_lookup_burn_rate_uuid UNIQUE ( burn_rate_uuid ) ,
	CONSTRAINT unq_info_event_lookup_cac_uuid UNIQUE ( cac_uuid ) ,
	CONSTRAINT unq_info_event_lookup_f_revenue_uuid UNIQUE ( f_revenue_uuid ) ,
	CONSTRAINT unq_info_event_lookup_gross_margin_uuid UNIQUE ( gross_margin_uuid ) ,
	CONSTRAINT unq_info_event_lookup_info_event_uuid UNIQUE ( info_event_uuid, h_revenue_uuid ) ,
	CONSTRAINT unq_info_event_lookup_ltv_uuid UNIQUE ( ltv_uuid )
 );

ALTER TABLE "public".info_event_lookup ADD CONSTRAINT fk_info_event_lookup FOREIGN KEY ( company_uuid ) REFERENCES "public".company_lookup( company_uuid );

CREATE  TABLE "public".financial_metrics (
	financial_metrics_uuid uuid  NOT NULL ,
	info_event_uuid      uuid  NOT NULL ,
	h_rev_uuid           uuid   ,
	f_rev_uuid           uuid   ,
	gross_marign_uuid    uuid   ,
	burn_rate_uuid       uuid   ,
	CONSTRAINT pk_financial_metrics_financial_metrics_uuid PRIMARY KEY ( financial_metrics_uuid ),
	CONSTRAINT unq_financial_metrics_burn_rate_uuid UNIQUE ( burn_rate_uuid ) ,
	CONSTRAINT unq_financial_metrics_gross_marign_uuid UNIQUE ( gross_marign_uuid ) ,
	CONSTRAINT unq_financial_metrics_f_rev_uuid UNIQUE ( f_rev_uuid ) ,
	CONSTRAINT unq_financial_metrics_h_rev_uuid UNIQUE ( h_rev_uuid )
 );

ALTER TABLE "public".financial_metrics ADD CONSTRAINT fk_financial_metrics FOREIGN KEY ( info_event_uuid ) REFERENCES "public".info_event_lookup( info_event_uuid );

CREATE  TABLE "public".burn_rate (
	burn_rate_uuid       uuid  NOT NULL ,
	monthly_burn_rate_value float8  NOT NULL ,
	burn_rate_scenario   text  NOT NULL ,
	burn_rate_currency   char(3)  NOT NULL ,
	burn_rate_runway_months smallint  NOT NULL ,
	CONSTRAINT pk_burn_rate_burn_rate_uuid PRIMARY KEY ( burn_rate_uuid )
 );

ALTER TABLE "public".burn_rate ADD CONSTRAINT fk_burn_rate_info_event_lookup FOREIGN KEY ( burn_rate_uuid ) REFERENCES "public".financial_metrics( burn_rate_uuid );

CREATE  TABLE "public".gross_margin (
	gross_margin_uuid    uuid  NOT NULL ,
	gross_margin_value   float8  NOT NULL ,
	gross_margin_scenario text  NOT NULL ,
	gross_margin_currency char(3)  NOT NULL ,
	gross_margin_date    date  NOT NULL ,
	gross_margin_date_precision text  NOT NULL ,
	gross_margin_period  text  NOT NULL ,
	CONSTRAINT pk_gross_margin_gross_margin_uuid PRIMARY KEY ( gross_margin_uuid )
 );

ALTER TABLE "public".gross_margin ADD CONSTRAINT gross_margin FOREIGN KEY ( gross_margin_uuid ) REFERENCES "public".financial_metrics( gross_marign_uuid );

CREATE  TABLE "public".f_revenue (
	f_revenue_uuid       uuid  NOT NULL ,
	f_revenue_value      float8  NOT NULL ,
	f_revenue_currency   char(3)  NOT NULL ,
	f_revenue_date       date  NOT NULL ,
	f_revenue_date_precision text  NOT NULL ,
	f_revenue_period     text  NOT NULL ,
	CONSTRAINT pk_f_revenue_f_revenue_uuid PRIMARY KEY ( f_revenue_uuid )
 );

COMMENT ON TABLE "public".f_revenue IS 'Earliest forecasted revenue as of formulating the pitch deck';

ALTER TABLE "public".f_revenue ADD CONSTRAINT f_revenue FOREIGN KEY ( f_revenue_uuid ) REFERENCES "public".financial_metrics( f_rev_uuid );

CREATE  TABLE "public".h_revenue (
	h_revenue_uuid       uuid  NOT NULL ,
	h_revenue_value      float8  NOT NULL ,
	h_revenue_currency   char(3)  NOT NULL ,
	h_revenue_date       date  NOT NULL ,
	h_revenue_date_precision text  NOT NULL ,
	h_revenue_period     text  NOT NULL ,
	CONSTRAINT pk_h_revenue_h_revenue_uuid PRIMARY KEY ( h_revenue_uuid )
 );

COMMENT ON TABLE "public".h_revenue IS 'Historical Revenue (H.Rev): Most recent realized revenue as of formulating the pitch deck';

ALTER TABLE "public".h_revenue ADD CONSTRAINT fk_h_revenue_financial_metrics FOREIGN KEY ( h_revenue_uuid ) REFERENCES "public".financial_metrics( h_rev_uuid );

CREATE  TABLE "public".marketing_metrics (
	marketing_metrics_uuid uuid  NOT NULL ,
	info_event_uuid      uuid  NOT NULL ,
	cac_uuid             uuid   ,
	ltv_uuid             uuid   ,
	aov_uuid             uuid   ,
	CONSTRAINT pk_marketing_metrics_marketing_metrics_uuid PRIMARY KEY ( marketing_metrics_uuid ),
	CONSTRAINT unq_marketing_metrics_ltv_uuid UNIQUE ( ltv_uuid ) ,
	CONSTRAINT unq_marketing_metrics_aov_uuid UNIQUE ( aov_uuid ) ,
	CONSTRAINT unq_marketing_metrics_cac_uuid UNIQUE ( cac_uuid )
 );

ALTER TABLE "public".marketing_metrics ADD CONSTRAINT fk_marketing_metrics FOREIGN KEY ( info_event_uuid ) REFERENCES "public".info_event_lookup( info_event_uuid );

CREATE  TABLE "public".ltv (
	ltv_uuid             uuid  NOT NULL ,
	ltv_value            float8  NOT NULL ,
	ltv_scenario         text  NOT NULL ,
	ltv_currency         char(3)  NOT NULL ,
	ltv_date             date  NOT NULL ,
	ltv_date_precision   text  NOT NULL ,
	ltv_expected_relationship_years float8   ,
	CONSTRAINT pk_ltv_ltv_uuid PRIMARY KEY ( ltv_uuid )
 );

COMMENT ON TABLE "public".ltv IS 'Average customer lifetime value to company (gross); expected amount of revenue per client';

ALTER TABLE "public".ltv ADD CONSTRAINT fk_ltv_info_event_lookup FOREIGN KEY ( ltv_uuid ) REFERENCES "public".marketing_metrics( ltv_uuid );

CREATE  TABLE "public".aov (
	aov_uuid             uuid  NOT NULL ,
	aov_value            float8  NOT NULL ,
	aov_scenario         text  NOT NULL ,
	aov_currency         char(3)  NOT NULL ,
	aov_date             date  NOT NULL ,
	aov_date_precision   text  NOT NULL ,
	CONSTRAINT pk_aov_aov_uuid PRIMARY KEY ( aov_uuid )
 );

COMMENT ON TABLE "public".aov IS 'Average Order Value (AOV)';

ALTER TABLE "public".aov ADD CONSTRAINT fk_aov_info_event_lookup FOREIGN KEY ( aov_uuid ) REFERENCES "public".marketing_metrics( aov_uuid );

CREATE  TABLE "public".cac (
	cac_uuid             uuid  NOT NULL ,
	cac_value            float8  NOT NULL ,
	cac_scenario         text  NOT NULL ,
	cac_currency         char(3)  NOT NULL ,
	cac_date             date  NOT NULL ,
	cac_date_precision   text  NOT NULL ,
	CONSTRAINT pk_cac_cac_uuid PRIMARY KEY ( cac_uuid )
 );

COMMENT ON TABLE "public".cac IS 'Customer Acquisition Cost (CAC): Average cost of acquiring a customer';

ALTER TABLE "public".cac ADD CONSTRAINT fk_cac_info_event_lookup FOREIGN KEY ( cac_uuid ) REFERENCES "public".marketing_metrics( cac_uuid );

CREATE  TABLE "public".fundraising (
	fundraising_uuid     uuid  NOT NULL ,
	info_event_uuid      uuid  NOT NULL ,
	ask_uuid             uuid   ,
	pre_m_uuid           uuid   ,
	CONSTRAINT pk_fundraising_fundraising_uuid PRIMARY KEY ( fundraising_uuid ),
	CONSTRAINT unq_fundraising_ask_uuid UNIQUE ( ask_uuid ) ,
	CONSTRAINT unq_fundraising_pre_m_uuid UNIQUE ( pre_m_uuid )
 );

ALTER TABLE "public".fundraising ADD CONSTRAINT fk_fundraising FOREIGN KEY ( info_event_uuid ) REFERENCES "public".info_event_lookup( info_event_uuid );

CREATE  TABLE "public".pre_m (
	pre_m_uuid           uuid  NOT NULL ,
	pre_m_valuation      float8  NOT NULL ,
	pre_m_scenario       text  NOT NULL ,
	pre_m_currency       char(3)  NOT NULL ,
	pre_m_date           date  NOT NULL ,
	pre_m_date_precision text  NOT NULL ,
	CONSTRAINT pk_pre_m_pre_m_uuid PRIMARY KEY ( pre_m_uuid )
 );

COMMENT ON TABLE "public".pre_m IS 'Value of company prior to current funding round';

ALTER TABLE "public".pre_m ADD CONSTRAINT fk_pre_m_pre_m FOREIGN KEY ( pre_m_uuid ) REFERENCES "public".fundraising( pre_m_uuid );

CREATE  TABLE "public".ask (
	ask_uuid             uuid  NOT NULL ,
	ask_value            float8  NOT NULL ,
	ask_currency         char(3)  NOT NULL ,
	ask_date             date  NOT NULL ,
	ask_date_precision   text  NOT NULL ,
	ask_lower_bound      float8   ,
	ask_upper_bound      float8   ,
	ask_already_committed float8   ,
	CONSTRAINT pk_ask_ask_uuid PRIMARY KEY ( ask_uuid )
 );

COMMENT ON TABLE "public".ask IS 'Amount of funding the company is seeking in the current investment round';

ALTER TABLE "public".ask ADD CONSTRAINT fk_ask_fundraising FOREIGN KEY ( ask_uuid ) REFERENCES "public".fundraising( ask_uuid );
