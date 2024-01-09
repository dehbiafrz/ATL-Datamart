-- Utilisation de la table Location
INSERT INTO Location (LocationID, name_borough, zoneID)
SELECT LocationID, name_borough, zoneID
FROM nyc_row;

-- Utilisation de la table LocationDetails
INSERT INTO LocationDetails (LocationID, LocationType)
SELECT LocationID, LocationType
FROM nyc_row;

-- Utilisation de la table Vendor
INSERT INTO Vendor (VendorID, name_vendor)
SELECT VendorID, name_vendor
FROM nyc_row;

-- Utilisation de la table VendorDetails
INSERT INTO VendorDetails (VendorID, VendorType)
SELECT VendorID, VendorType
FROM nyc_row;

-- Utilisation de la table Ratecode
INSERT INTO Ratecode (RatecodeID, name_rate_code)
SELECT RatecodeID, name_rate_code
FROM nyc_row;

-- Utilisation de la table RatecodeDetails
INSERT INTO RatecodeDetails (RatecodeID, RatecodeType)
SELECT RatecodeID, RatecodeType
FROM nyc_row;

-- Utilisation de la table Time
INSERT INTO Time (TimeID, PickupHour, PickupDay, PickupMonth, PickupYear)
SELECT TimeID, EXTRACT(HOUR FROM tpep_pickup_datetime), EXTRACT(DAY FROM tpep_pickup_datetime), EXTRACT(MONTH FROM tpep_pickup_datetime), EXTRACT(YEAR FROM tpep_pickup_datetime)
FROM nyc_row;

-- Utilisation de la table TimeDetails
INSERT INTO TimeDetails (TimeID, HolidayType)
SELECT TimeID, HolidayType
FROM nyc_row;

-- Utilisation de la table PaymentType
INSERT INTO PaymentType (PaymentTypeID, name_payment_type)
SELECT payment_typeID, name_payment_type
FROM nyc_row;

-- Utilisation de la table PaymentTypeDetails
INSERT INTO PaymentTypeDetails (PaymentTypeID, CardNetwork)
SELECT payment_typeID, CardNetwork
FROM nyc_row;

-- Utilisation de la table Trip
INSERT INTO Trip (
    TripID, VendorID, tpep_pickup_datetime, tpep_dropoff_datetime,
    passenger_count, trip_distance, RatecodeID, store_and_fwd_flag,
    PULocationID, DOLocationID, payment_type, fare_amount, extra,
    mta_tax, tip_amount, tolls_amount, improvement_surcharge,
    total_amount, congestion_surcharge, airport_fee
)
SELECT
    TripID, VendorID, tpep_pickup_datetime, tpep_dropoff_datetime,
    passenger_count, trip_distance, RatecodeID, store_and_fwd_flag,
    PULocationID, DOLocationID, payment_type, fare_amount, extra,
    mta_tax, tip_amount, tolls_amount, improvement_surcharge,
    total_amount, congestion_surcharge, airport_fee
FROM nyc_row;
