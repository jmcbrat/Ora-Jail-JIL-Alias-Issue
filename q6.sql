select CITY_TOWN_LOCALE from EH_ADDRESS where (   regexp_like(CITY_TOWN_LOCALE, '[0-9]{3}\-[0-9]{2}\-[0-9]{4}')    or regexp_like(CITY_TOWN_LOCALE, '[0-9]{9}'))  ;
