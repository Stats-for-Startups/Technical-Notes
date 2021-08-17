/* Step 2: Create all tables */

CREATE  TABLE "public".company_lookup ( 
	company_uuid         uuid  NOT NULL ,
	streak_charge_uuid   uuid  NOT NULL ,
	cb_org_uuid          uuid   ,
	revenue_model        text   ,
	secondary_revenue_model text   ,
	customer_acquisition_channel text   ,
	secondary_customer_acquisition_channel text   ,
	CONSTRAINT pk_company_lookup_company_uuid PRIMARY KEY ( company_uuid )
 );

COMMENT ON TABLE "public".company_lookup IS 'This table reps=resents the Company hierarchy in the Charge Ventures database';

COMMENT ON COLUMN "public".company_lookup.streak_charge_uuid IS 'links to the streak st_newcos row in the database';

CREATE  TABLE "public".market_lookup ( 
	company_uuid         uuid  NOT NULL ,
	industry             text   ,
	"source"             text   
 );

COMMENT ON TABLE "public".market_lookup IS '"flat" file containing all the market designations for a given company. the industries are specified per the crunchbase schema';

ALTER TABLE "public".market_lookup ADD CONSTRAINT company_uuid FOREIGN KEY ( company_uuid ) REFERENCES "public".company_lookup( company_uuid );

CREATE  TABLE "public".founder_linkedins ( 
	company_uuid         uuid  NOT NULL ,
	linkedin_url         text   
 );

COMMENT ON TABLE "public".founder_linkedins IS 'collection of all the linkedin links found for the company founders';

ALTER TABLE "public".founder_linkedins ADD CONSTRAINT company_uuid FOREIGN KEY ( company_uuid ) REFERENCES "public".company_lookup( company_uuid );

CREATE  TABLE "public".info_event_lookup ( 
	info_event_uuid      uuid  NOT NULL ,
	info_event_date      date   ,
	cb_round_uuid        uuid   ,
	user_revenue         text   ,
	product_stage        text   ,
	company_uuid         uuid  NOT NULL ,
	CONSTRAINT pk_info_event_lookup_info_event_uuid PRIMARY KEY ( info_event_uuid )
 );

ALTER TABLE "public".info_event_lookup ADD CONSTRAINT fk_info_event_lookup FOREIGN KEY ( company_uuid ) REFERENCES "public".company_lookup( company_uuid );

CREATE  TABLE "public".deck_attributes ( 
	market_size_slide    boolean  NOT NULL ,
	team_slide           boolean  NOT NULL ,
	why_now_slide        boolean  NOT NULL ,
	problem_slide        boolean  NOT NULL ,
	deck_attributes_uuid uuid  NOT NULL ,
	solution_slide       boolean  NOT NULL ,
	company_purpose_slide boolean  NOT NULL ,
	traction_slide       boolean  NOT NULL ,
	competition_slide    boolean  NOT NULL ,
	business_model_slide boolean  NOT NULL ,
	financials_slide     boolean  NOT NULL ,
	fundraising_ask_slide boolean  NOT NULL ,
	gtm_slide            boolean  NOT NULL ,
	product_slide        boolean  NOT NULL ,
	info_event_uuid      uuid  NOT NULL ,
	CONSTRAINT pk_deck_attributes_deck_attributes_uuid PRIMARY KEY ( deck_attributes_uuid )
 );

COMMENT ON TABLE "public".deck_attributes IS 'Presence of a slide type in the deck per Docsend''s attribute list';

ALTER TABLE "public".deck_attributes ADD CONSTRAINT fk_deck_attributes FOREIGN KEY ( info_event_uuid ) REFERENCES "public".info_event_lookup( info_event_uuid );

CREATE  TABLE "public".pt_financials ( 
	financial_kpi        uuid  NOT NULL ,
	info_event_uuid      uuid  NOT NULL ,
	element_type         text  NOT NULL ,
	element_value        bigint  NOT NULL ,
	element_scenario     text  NOT NULL ,
	element_unit         text  NOT NULL ,
	element_date         date  NOT NULL ,
	element_date_precision text  NOT NULL ,
	CONSTRAINT pk_pt_financials_financial_kpi PRIMARY KEY ( financial_kpi )
 );

ALTER TABLE "public".pt_financials ADD CONSTRAINT fk_pt_financials FOREIGN KEY ( info_event_uuid ) REFERENCES "public".info_event_lookup( info_event_uuid );

CREATE  TABLE "public".pt_market ( 
	market_uuid          uuid  NOT NULL ,
	element_value        float8  NOT NULL ,
	element_scenario     text  NOT NULL ,
	element_currency     char(3)  NOT NULL ,
	element_date         date  NOT NULL ,
	element_date_precision text  NOT NULL ,
	element_geography    text  NOT NULL ,
	element_source       text   ,
	element_source_date  text   ,
	element_past_growth_rate_yearly integer   ,
	element_future_growth_rate_yearly integer   ,
	info_event_uuid      uuid  NOT NULL ,
	element_type         text  NOT NULL ,
	CONSTRAINT pk_pt_market_uuid PRIMARY KEY ( market_uuid )
 );

ALTER TABLE "public".pt_market ADD CONSTRAINT fk_pt_market_info_event_lookup FOREIGN KEY ( info_event_uuid ) REFERENCES "public".info_event_lookup( info_event_uuid );



