<#
Copyright 2015 Brandon Olin

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

function Get-NSAvailableTimeZone {
    <#
    .SYNOPSIS
        Get list of available timezones to set on NetScaler.

    .DESCRIPTION
        Get list of available timezones to set on NetScaler.

    .EXAMPLE
        Get-NSAvailableTimeZone

        Retrieves list of available timezones.
    #>

    #Count is 411 time zones
    return @(
        'CoordinatedUniversalTime',
        'GMT+00:00-GMT-Africa/Abidjan','GMT+00:00-GMT-Africa/Accra','GMT+00:00-GMT-Africa/Bamako','GMT+00:00-GMT-Africa/Banjul','GMT+00:00-GMT-Africa/Bissau','GMT+00:00-GMT-Africa/Conakry','GMT+00:00-GMT-Africa/Dakar','GMT+00:00-GMT-Africa/Freetown','GMT+00:00-GMT-Africa/Lome','GMT+00:00-GMT-Africa/Monrovia','GMT+00:00-GMT-Africa/Nouakchott','GMT+00:00-GMT-Africa/Ouagadougou','GMT+00:00-GMT-Africa/Sao_Tome','GMT+00:00-GMT-America/Danmarkshavn','GMT+00:00-GMT-Atlantic/Reykjavik','GMT+00:00-GMT-Atlantic/St_Helena','GMT+00:00-GMT-Europe/Dublin','GMT+00:00-GMT-Europe/Guernsey','GMT+00:00-GMT-Europe/Isle_of_Man','GMT+00:00-GMT-Europe/Jersey','GMT+00:00-GMT-Europe/London','GMT+00:00-WET-Africa/Casablanca','GMT+00:00-WET-Africa/El_Aaiun','GMT+00:00-WET-Atlantic/Canary','GMT+00:00-WET-Atlantic/Faroe','GMT+00:00-WET-Atlantic/Madeira','GMT+00:00-WET-Europe/Lisbon',
        'GMT+01:00-CET-Africa/Algiers','GMT+01:00-CET-Africa/Ceuta','GMT+01:00-CET-Africa/Tunis','GMT+01:00-CET-Arctic/Longyearbyen','GMT+01:00-CET-Europe/Amsterdam','GMT+01:00-CET-Europe/Andorra','GMT+01:00-CET-Europe/Belgrade','GMT+01:00-CET-Europe/Berlin','GMT+01:00-CET-Europe/Bratislava','GMT+01:00-CET-Europe/Brussels','GMT+01:00-CET-Europe/Budapest','GMT+01:00-CET-Europe/Copenhagen','GMT+01:00-CET-Europe/Gibraltar','GMT+01:00-CET-Europe/Ljubljana','GMT+01:00-CET-Europe/Luxembourg','GMT+01:00-CET-Europe/Madrid','GMT+01:00-CET-Europe/Malta','GMT+01:00-CET-Europe/Monaco','GMT+01:00-CET-Europe/Oslo','GMT+01:00-CET-Europe/Paris','GMT+01:00-CET-Europe/Podgorica','GMT+01:00-CET-Europe/Prague','GMT+01:00-CET-Europe/Rome','GMT+01:00-CET-Europe/San_Marino','GMT+01:00-CET-Europe/Sarajevo','GMT+01:00-CET-Europe/Skopje','GMT+01:00-CET-Europe/Stockholm','GMT+01:00-CET-Europe/Tirane','GMT+01:00-CET-Europe/Vaduz','GMT+01:00-CET-Europe/Vatican','GMT+01:00-CET-Europe/Vienna','GMT+01:00-CET-Europe/Warsaw','GMT+01:00-CET-Europe/Zagreb','GMT+01:00-CET-Europe/Zurich','GMT+01:00-WAT-Africa/Bangui','GMT+01:00-WAT-Africa/Brazzaville','GMT+01:00-WAT-Africa/Douala','GMT+01:00-WAT-Africa/Kinshasa','GMT+01:00-WAT-Africa/Lagos','GMT+01:00-WAT-Africa/Libreville','GMT+01:00-WAT-Africa/Luanda','GMT+01:00-WAT-Africa/Malabo','GMT+01:00-WAT-Africa/Ndjamena','GMT+01:00-WAT-Africa/Niamey','GMT+01:00-WAT-Africa/Porto-Novo',
        'GMT+02:00-CAT-Africa/Blantyre','GMT+02:00-CAT-Africa/Bujumbura','GMT+02:00-CAT-Africa/Gaborone','GMT+02:00-CAT-Africa/Harare','GMT+02:00-CAT-Africa/Kigali','GMT+02:00-CAT-Africa/Lubumbashi','GMT+02:00-CAT-Africa/Lusaka','GMT+02:00-CAT-Africa/Maputo','GMT+02:00-EET-Africa/Cairo','GMT+02:00-EET-Africa/Tripoli','GMT+02:00-EET-Asia/Amman','GMT+02:00-EET-Asia/Beirut','GMT+02:00-EET-Asia/Damascus','GMT+02:00-EET-Asia/Gaza','GMT+02:00-EET-Asia/Hebron','GMT+02:00-EET-Asia/Nicosia','GMT+02:00-EET-Europe/Athens','GMT+02:00-EET-Europe/Bucharest','GMT+02:00-EET-Europe/Chisinau','GMT+02:00-EET-Europe/Helsinki','GMT+02:00-EET-Europe/Istanbul','GMT+02:00-EET-Europe/Kiev','GMT+02:00-EET-Europe/Mariehamn','GMT+02:00-EET-Europe/Riga','GMT+02:00-EET-Europe/Simferopol','GMT+02:00-EET-Europe/Sofia','GMT+02:00-EET-Europe/Tallinn','GMT+02:00-EET-Europe/Uzhgorod','GMT+02:00-EET-Europe/Vilnius','GMT+02:00-EET-Europe/Zaporozhye','GMT+02:00-IST-Asia/Jerusalem','GMT+02:00-SAST-Africa/Johannesburg','GMT+02:00-SAST-Africa/Maseru','GMT+02:00-SAST-Africa/Mbabane','GMT+02:00-WAST-Africa/Windhoek',
        'GMT+03:00-AST-Asia/Aden','GMT+03:00-AST-Asia/Baghdad','GMT+03:00-AST-Asia/Bahrain','GMT+03:00-AST-Asia/Kuwait','GMT+03:00-AST-Asia/Qatar','GMT+03:00-AST-Asia/Riyadh','GMT+03:00-EAT-Africa/Addis_Ababa','GMT+03:00-EAT-Africa/Asmara','GMT+03:00-EAT-Africa/Dar_es_Salaam','GMT+03:00-EAT-Africa/Djibouti','GMT+03:00-EAT-Africa/Kampala','GMT+03:00-EAT-Africa/Khartoum','GMT+03:00-EAT-Africa/Mogadishu','GMT+03:00-EAT-Africa/Nairobi','GMT+03:00-EAT-Indian/Antananarivo','GMT+03:00-EAT-Indian/Comoro','GMT+03:00-EAT-Indian/Mayotte','GMT+03:00-FET-Europe/Kaliningrad','GMT+03:00-FET-Europe/Minsk','GMT+03:00-SYOT-Antarctica/Syowa',
        'GMT+03:30-IRST-Asia/Tehran',
        'GMT+04:00-AMT-Asia/Yerevan','GMT+04:00-AZT-Asia/Baku','GMT+04:00-GET-Asia/Tbilisi','GMT+04:00-GST-Asia/Dubai','GMT+04:00-GST-Asia/Muscat','GMT+04:00-MSK-Europe/Moscow','GMT+04:00-MUT-Indian/Mauritius','GMT+04:00-RET-Indian/Reunion','GMT+04:00-SAMT-Europe/Samara','GMT+04:00-SCT-Indian/Mahe','GMT+04:00-VOLT-Europe/Volgograd',
        'GMT+04:30-AFT-Asia/Kabul',
        'GMT+05:00-AQTT-Asia/Aqtau','GMT+05:00-AQTT-Asia/Aqtobe','GMT+05:00-MAWT-Antarctica/Mawson','GMT+05:00-MVT-Indian/Maldives',
        'GMT+05:00-ORAT-Asia/Oral','GMT+05:00-PKT-Asia/Karachi','GMT+05:00-TFT-Indian/Kerguelen','GMT+05:00-TJT-Asia/Dushanbe','GMT+05:00-TMT-Asia/Ashgabat','GMT+05:00-UZT-Asia/Samarkand','GMT+05:00-UZT-Asia/Tashkent',
        'GMT+05:30-IST-Asia/Colombo','GMT+05:30-IST-Asia/Kolkata',
        'GMT+05:45-NPT-Asia/Kathmandu',
        'GMT+06:00-ALMT-Asia/Almaty','GMT+06:00-BDT-Asia/Dhaka','GMT+06:00-BTT-Asia/Thimphu','GMT+06:00-IOT-Indian/Chagos','GMT+06:00-KGT-Asia/Bishkek','GMT+06:00-QYZT-Asia/Qyzylorda','GMT+06:00-VOST-Antarctica/Vostok','GMT+06:00-YEKT-Asia/Yekaterinburg',
        'GMT+06:30-CCT-Indian/Cocos','GMT+06:30-MMT-Asia/Rangoon',
        'GMT+07:00-CXT-Indian/Christmas','GMT+07:00-DAVT-Antarctica/Davis','GMT+07:00-HOVT-Asia/Hovd','GMT+07:00-ICT-Asia/Bangkok','GMT+07:00-ICT-Asia/Ho_Chi_Minh','GMT+07:00-ICT-Asia/Phnom_Penh','GMT+07:00-ICT-Asia/Vientiane','GMT+07:00-NOVT-Asia/Novokuznetsk','GMT+07:00-NOVT-Asia/Novosibirsk','GMT+07:00-OMST-Asia/Omsk','GMT+07:00-WIT-Asia/Jakarta','GMT+07:00-WIT-Asia/Pontianak',
        'GMT+08:00-BNT-Asia/Brunei','GMT+08:00-CHOT-Asia/Choibalsan','GMT+08:00-CIT-Asia/Makassar','GMT+08:00-CST-Asia/Chongqing','GMT+08:00-CST-Asia/Harbin','GMT+08:00-CST-Asia/Kashgar','GMT+08:00-CST-Asia/Macau','GMT+08:00-CST-Asia/Shanghai','GMT+08:00-CST-Asia/Taipei','GMT+08:00-CST-Asia/Urumqi','GMT+08:00-HKT-Asia/Hong_Kong','GMT+08:00-KRAT-Asia/Krasnoyarsk','GMT+08:00-MYT-Asia/Kuala_Lumpur','GMT+08:00-MYT-Asia/Kuching','GMT+08:00-PHT-Asia/Manila','GMT+08:00-SGT-Asia/Singapore','GMT+08:00-ULAT-Asia/Ulaanbaatar','GMT+08:00-WST-Antarctica/Casey','GMT+08:00-WST-Australia/Perth',
        'GMT+08:45-CWST-Australia/Eucla',
        'GMT+09:00-EIT-Asia/Jayapura','GMT+09:00-IRKT-Asia/Irkutsk','GMT+09:00-JST-Asia/Tokyo','GMT+09:00-KST-Asia/Pyongyang','GMT+09:00-KST-Asia/Seoul','GMT+09:00-PWT-Pacific/Palau','GMT+09:00-TLT-Asia/Dili',
        'GMT+09:30-CST-Australia/Darwin',
        'GMT+10:00-ChST-Pacific/Guam','GMT+10:00-ChST-Pacific/Saipan','GMT+10:00-CHUT-Pacific/Chuuk','GMT+10:00-DDUT-Antarctica/DumontDUrville','GMT+10:00-EST-Australia/Brisbane','GMT+10:00-EST-Australia/Lindeman','GMT+10:00-PGT-Pacific/Port_Moresby','GMT+10:00-YAKT-Asia/Yakutsk',
        'GMT+10:30-CST-Australia/Adelaide','GMT+10:30-CST-Australia/Broken_Hill',
        'GMT+11:00-EST-Australia/Currie','GMT+11:00-EST-Australia/Hobart','GMT+11:00-EST-Australia/Melbourne','GMT+11:00-EST-Australia/Sydney','GMT+11:00-KOST-Pacific/Kosrae','GMT+11:00-LHST-Australia/Lord_Howe','GMT+11:00-MIST-Antarctica/Macquarie','GMT+11:00-NCT-Pacific/Noumea','GMT+11:00-PONT-Pacific/Pohnpei','GMT+11:00-SAKT-Asia/Sakhalin','GMT+11:00-SBT-Pacific/Guadalcanal','GMT+11:00-VLAT-Asia/Vladivostok','GMT+11:00-VUT-Pacific/Efate',
        'GMT+11:30-NFT-Pacific/Norfolk',
        'GMT+12:00-ANAT-Asia/Anadyr','GMT+12:00-FJT-Pacific/Fiji','GMT+12:00-GILT-Pacific/Tarawa','GMT+12:00-MAGT-Asia/Magadan','GMT+12:00-MHT-Pacific/Kwajalein','GMT+12:00-MHT-Pacific/Majuro','GMT+12:00-NRT-Pacific/Nauru','GMT+12:00-PETT-Asia/Kamchatka','GMT+12:00-TVT-Pacific/Funafuti','GMT+12:00-WAKT-Pacific/Wake','GMT+12:00-WFT-Pacific/Wallis',
        'GMT+13:00-NZDT-Antarctica/McMurdo',
        'GMT+13:00-NZDT-Antarctica/South_Pole','GMT+13:00-NZDT-Pacific/Auckland','GMT+13:00-PHOT-Pacific/Enderbury','GMT+13:00-TOT-Pacific/Tongatapu',
        'GMT+13:45-CHADT-Pacific/Chatham',
        'GMT+14:00-LINT-Pacific/Kiritimati','GMT+14:00-WSDT-Pacific/Apia',
        'GMT-01:00-AZOT-Atlantic/Azores','GMT-01:00-CVT-Atlantic/Cape_Verde','GMT-01:00-EGT-America/Scoresbysund',
        'GMT-02:00-FNT-America/Noronha','GMT-02:00-GST-Atlantic/South_Georgia','GMT-02:00-PMDT-America/Miquelon',
        'GMT-02:30-NDT-America/St_Johns',
        'GMT-03:00-ADT-America/Glace_Bay','GMT-03:00-ADT-America/Goose_Bay','GMT-03:00-ADT-America/Halifax','GMT-03:00-ADT-America/Moncton','GMT-03:00-ADT-America/Thule','GMT-03:00-ADT-Atlantic/Bermuda','GMT-03:00-ART-America/Argentina/Buenos_Aires','GMT-03:00-ART-America/Argentina/Catamarca','GMT-03:00-ART-America/Argentina/Cordoba','GMT-03:00-ART-America/Argentina/Jujuy','GMT-03:00-ART-America/Argentina/La_Rioja','GMT-03:00-ART-America/Argentina/Mendoza','GMT-03:00-ART-America/Argentina/Rio_Gallegos','GMT-03:00-ART-America/Argentina/Salta','GMT-03:00-ART-America/Argentina/San_Juan','GMT-03:00-ART-America/Argentina/Tucuman','GMT-03:00-ART-America/Argentina/Ushuaia','GMT-03:00-BRT-America/Araguaina','GMT-03:00-BRT-America/Bahia','GMT-03:00-BRT-America/Belem','GMT-03:00-BRT-America/Fortaleza','GMT-03:00-BRT-America/Maceio','GMT-03:00-BRT-America/Recife','GMT-03:00-BRT-America/Santarem','GMT-03:00-BRT-America/Sao_Paulo','GMT-03:00-FKST-Atlantic/Stanley','GMT-03:00-GFT-America/Cayenne','GMT-03:00-PYST-America/Asuncion','GMT-03:00-ROTT-Antarctica/Rothera','GMT-03:00-SRT-America/Paramaribo','GMT-03:00-UYT-America/Montevideo','GMT-03:00-WARST-America/Argentina/San_Luis','GMT-03:00-WGT-America/Godthab',
        'GMT-04:00-AMT-America/Boa_Vista','GMT-04:00-AMT-America/Campo_Grande','GMT-04:00-AMT-America/Cuiaba','GMT-04:00-AMT-America/Eirunepe','GMT-04:00-AMT-America/Manaus','GMT-04:00-AMT-America/Porto_Velho','GMT-04:00-AMT-America/Rio_Branco','GMT-04:00-AST-America/Anguilla','GMT-04:00-AST-America/Antigua','GMT-04:00-AST-America/Aruba','GMT-04:00-AST-America/Barbados','GMT-04:00-AST-America/Blanc-Sablon','GMT-04:00-AST-America/Dominica','GMT-04:00-AST-America/Grenada','GMT-04:00-AST-America/Guadeloupe','GMT-04:00-AST-America/Marigot','GMT-04:00-AST-America/Martinique','GMT-04:00-AST-America/Montserrat','GMT-04:00-AST-America/Port_of_Spain','GMT-04:00-AST-America/Puerto_Rico','GMT-04:00-AST-America/Santo_Domingo','GMT-04:00-AST-America/St_Barthelemy','GMT-04:00-AST-America/St_Kitts','GMT-04:00-AST-America/St_Lucia','GMT-04:00-AST-America/St_Thomas','GMT-04:00-AST-America/St_Vincent','GMT-04:00-AST-America/Tortola','GMT-04:00-BOT-America/La_Paz','GMT-04:00-CDT-America/Havana','GMT-04:00-CLT-America/Santiago','GMT-04:00-CLT-Antarctica/Palmer','GMT-04:00-EDT-America/Detroit','GMT-04:00-EDT-America/Grand_Turk','GMT-04:00-EDT-America/Indiana/Indianapolis','GMT-04:00-EDT-America/Indiana/Marengo','GMT-04:00-EDT-America/Indiana/Petersburg','GMT-04:00-EDT-America/Indiana/Vevay','GMT-04:00-EDT-America/Indiana/Vincennes','GMT-04:00-EDT-America/Indiana/Winamac','GMT-04:00-EDT-America/Iqaluit','GMT-04:00-EDT-America/Kentucky/Louisville','GMT-04:00-EDT-America/Kentucky/Monticello','GMT-04:00-EDT-America/Montreal','GMT-04:00-EDT-America/Nassau','GMT-04:00-EDT-America/New_York','GMT-04:00-EDT-America/Nipigon','GMT-04:00-EDT-America/Pangnirtung','GMT-04:00-EDT-America/Thunder_Bay','GMT-04:00-EDT-America/Toronto','GMT-04:00-GYT-America/Guyana',
        'GMT-04:30-VET-America/Caracas',
        'GMT-05:00-CDT-America/Chicago','GMT-05:00-CDT-America/Indiana/Knox','GMT-05:00-CDT-America/Indiana/Tell_City','GMT-05:00-CDT-America/Matamoros','GMT-05:00-CDT-America/Menominee','GMT-05:00-CDT-America/North_Dakota/Beulah','GMT-05:00-CDT-America/North_Dakota/Center','GMT-05:00-CDT-America/North_Dakota/New_Salem','GMT-05:00-CDT-America/Rainy_River','GMT-05:00-CDT-America/Rankin_Inlet','GMT-05:00-CDT-America/Resolute','GMT-05:00-CDT-America/Winnipeg','GMT-05:00-COT-America/Bogota','GMT-05:00-ECT-America/Guayaquil','GMT-05:00-EST-America/Atikokan','GMT-05:00-EST-America/Cayman','GMT-05:00-EST-America/Jamaica','GMT-05:00-EST-America/Panama','GMT-05:00-EST-America/Port-au-Prince','GMT-05:00-PET-America/Lima',
        'GMT-06:00-CST-America/Bahia_Banderas','GMT-06:00-CST-America/Belize',
        'GMT-06:00-CST-America/Cancun','GMT-06:00-CST-America/Costa_Rica','GMT-06:00-CST-America/El_Salvador','GMT-06:00-CST-America/Guatemala','GMT-06:00-CST-America/Managua',
        'GMT-06:00-CST-America/Merida','GMT-06:00-CST-America/Mexico_City','GMT-06:00-CST-America/Monterrey','GMT-06:00-CST-America/Regina','GMT-06:00-CST-America/Swift_Current',
        'GMT-06:00-CST-America/Tegucigalpa','GMT-06:00-EAST-Pacific/Easter','GMT-06:00-GALT-Pacific/Galapagos','GMT-06:00-MDT-America/Boise','GMT-06:00-MDT-America/Cambridge_Bay',
        'GMT-06:00-MDT-America/Denver','GMT-06:00-MDT-America/Edmonton','GMT-06:00-MDT-America/Inuvik','GMT-06:00-MDT-America/Ojinaga','GMT-06:00-MDT-America/Shiprock',
        'GMT-06:00-MDT-America/Yellowknife',
        'GMT-07:00-MST-America/Chihuahua','GMT-07:00-MST-America/Dawson_Creek','GMT-07:00-MST-America/Hermosillo','GMT-07:00-MST-America/Mazatlan','GMT-07:00-MST-America/Phoenix','GMT-07:00-PDT-America/Dawson','GMT-07:00-PDT-America/Los_Angeles','GMT-07:00-PDT-America/Tijuana','GMT-07:00-PDT-America/Vancouver','GMT-07:00-PDT-America/Whitehorse',
        'GMT-08:00-AKDT-America/Anchorage','GMT-08:00-AKDT-America/Juneau','GMT-08:00-AKDT-America/Nome','GMT-08:00-AKDT-America/Sitka','GMT-08:00-AKDT-America/Yakutat','GMT-08:00-MeST-America/Metlakatla','GMT-08:00-PST-America/Santa_Isabel','GMT-08:00-PST-Pacific/Pitcairn',
        'GMT-09:00-GAMT-Pacific/Gambier','GMT-09:00-HADT-America/Adak',
        'GMT-09:30-MART-Pacific/Marquesas',
        'GMT-10:00-CKT-Pacific/Rarotonga','GMT-10:00-HST-Pacific/Honolulu','GMT-10:00-HST-Pacific/Johnston','GMT-10:00-TAHT-Pacific/Tahiti','GMT-10:00-TKT-Pacific/Fakaofo',
        'GMT-11:00-NUT-Pacific/Niue','GMT-11:00-SST-Pacific/Midway','GMT-11:00-SST-Pacific/Pago_Pago'
    )
}