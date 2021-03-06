\set ON_ERROR_STOP 1
BEGIN;
drop schema if exists summary cascade;
create schema summary;
set search_path=summary,public;

create table daily (
x integer,
y integer,
year integer,
month integer,
doy integer,
quad integer,
days integer,
tx float,
tx_min float,
tx_max float,
tx_stddev float,
tn float,
tn_min float,
tn_max float,
tn_stddev float,
pcp float,
pcp_min float,
pcp_max float,
pcp_stddev float,
nrf integer
);

CREATE OR REPLACE FUNCTION daily_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
CASE NEW.y
WHEN 000 THEN insert into summary.daily000 VALUES (NEW.*);
WHEN 001 THEN insert into summary.daily001 VALUES (NEW.*);
WHEN 002 THEN insert into summary.daily002 VALUES (NEW.*);
WHEN 003 THEN insert into summary.daily003 VALUES (NEW.*);
WHEN 004 THEN insert into summary.daily004 VALUES (NEW.*);
WHEN 005 THEN insert into summary.daily005 VALUES (NEW.*);
WHEN 006 THEN insert into summary.daily006 VALUES (NEW.*);
WHEN 007 THEN insert into summary.daily007 VALUES (NEW.*);
WHEN 008 THEN insert into summary.daily008 VALUES (NEW.*);
WHEN 009 THEN insert into summary.daily009 VALUES (NEW.*);
WHEN 010 THEN insert into summary.daily010 VALUES (NEW.*);
WHEN 011 THEN insert into summary.daily011 VALUES (NEW.*);
WHEN 012 THEN insert into summary.daily012 VALUES (NEW.*);
WHEN 013 THEN insert into summary.daily013 VALUES (NEW.*);
WHEN 014 THEN insert into summary.daily014 VALUES (NEW.*);
WHEN 015 THEN insert into summary.daily015 VALUES (NEW.*);
WHEN 016 THEN insert into summary.daily016 VALUES (NEW.*);
WHEN 017 THEN insert into summary.daily017 VALUES (NEW.*);
WHEN 018 THEN insert into summary.daily018 VALUES (NEW.*);
WHEN 019 THEN insert into summary.daily019 VALUES (NEW.*);
WHEN 020 THEN insert into summary.daily020 VALUES (NEW.*);
WHEN 021 THEN insert into summary.daily021 VALUES (NEW.*);
WHEN 022 THEN insert into summary.daily022 VALUES (NEW.*);
WHEN 023 THEN insert into summary.daily023 VALUES (NEW.*);
WHEN 024 THEN insert into summary.daily024 VALUES (NEW.*);
WHEN 025 THEN insert into summary.daily025 VALUES (NEW.*);
WHEN 026 THEN insert into summary.daily026 VALUES (NEW.*);
WHEN 027 THEN insert into summary.daily027 VALUES (NEW.*);
WHEN 028 THEN insert into summary.daily028 VALUES (NEW.*);
WHEN 029 THEN insert into summary.daily029 VALUES (NEW.*);
WHEN 030 THEN insert into summary.daily030 VALUES (NEW.*);
WHEN 031 THEN insert into summary.daily031 VALUES (NEW.*);
WHEN 032 THEN insert into summary.daily032 VALUES (NEW.*);
WHEN 033 THEN insert into summary.daily033 VALUES (NEW.*);
WHEN 034 THEN insert into summary.daily034 VALUES (NEW.*);
WHEN 035 THEN insert into summary.daily035 VALUES (NEW.*);
WHEN 036 THEN insert into summary.daily036 VALUES (NEW.*);
WHEN 037 THEN insert into summary.daily037 VALUES (NEW.*);
WHEN 038 THEN insert into summary.daily038 VALUES (NEW.*);
WHEN 039 THEN insert into summary.daily039 VALUES (NEW.*);
WHEN 040 THEN insert into summary.daily040 VALUES (NEW.*);
WHEN 041 THEN insert into summary.daily041 VALUES (NEW.*);
WHEN 042 THEN insert into summary.daily042 VALUES (NEW.*);
WHEN 043 THEN insert into summary.daily043 VALUES (NEW.*);
WHEN 044 THEN insert into summary.daily044 VALUES (NEW.*);
WHEN 045 THEN insert into summary.daily045 VALUES (NEW.*);
WHEN 046 THEN insert into summary.daily046 VALUES (NEW.*);
WHEN 047 THEN insert into summary.daily047 VALUES (NEW.*);
WHEN 048 THEN insert into summary.daily048 VALUES (NEW.*);
WHEN 049 THEN insert into summary.daily049 VALUES (NEW.*);
WHEN 050 THEN insert into summary.daily050 VALUES (NEW.*);
WHEN 051 THEN insert into summary.daily051 VALUES (NEW.*);
WHEN 052 THEN insert into summary.daily052 VALUES (NEW.*);
WHEN 053 THEN insert into summary.daily053 VALUES (NEW.*);
WHEN 054 THEN insert into summary.daily054 VALUES (NEW.*);
WHEN 055 THEN insert into summary.daily055 VALUES (NEW.*);
WHEN 056 THEN insert into summary.daily056 VALUES (NEW.*);
WHEN 057 THEN insert into summary.daily057 VALUES (NEW.*);
WHEN 058 THEN insert into summary.daily058 VALUES (NEW.*);
WHEN 059 THEN insert into summary.daily059 VALUES (NEW.*);
WHEN 060 THEN insert into summary.daily060 VALUES (NEW.*);
WHEN 061 THEN insert into summary.daily061 VALUES (NEW.*);
WHEN 062 THEN insert into summary.daily062 VALUES (NEW.*);
WHEN 063 THEN insert into summary.daily063 VALUES (NEW.*);
WHEN 064 THEN insert into summary.daily064 VALUES (NEW.*);
WHEN 065 THEN insert into summary.daily065 VALUES (NEW.*);
WHEN 066 THEN insert into summary.daily066 VALUES (NEW.*);
WHEN 067 THEN insert into summary.daily067 VALUES (NEW.*);
WHEN 068 THEN insert into summary.daily068 VALUES (NEW.*);
WHEN 069 THEN insert into summary.daily069 VALUES (NEW.*);
WHEN 070 THEN insert into summary.daily070 VALUES (NEW.*);
WHEN 071 THEN insert into summary.daily071 VALUES (NEW.*);
WHEN 072 THEN insert into summary.daily072 VALUES (NEW.*);
WHEN 073 THEN insert into summary.daily073 VALUES (NEW.*);
WHEN 074 THEN insert into summary.daily074 VALUES (NEW.*);
WHEN 075 THEN insert into summary.daily075 VALUES (NEW.*);
WHEN 076 THEN insert into summary.daily076 VALUES (NEW.*);
WHEN 077 THEN insert into summary.daily077 VALUES (NEW.*);
WHEN 078 THEN insert into summary.daily078 VALUES (NEW.*);
WHEN 079 THEN insert into summary.daily079 VALUES (NEW.*);
WHEN 080 THEN insert into summary.daily080 VALUES (NEW.*);
WHEN 081 THEN insert into summary.daily081 VALUES (NEW.*);
WHEN 082 THEN insert into summary.daily082 VALUES (NEW.*);
WHEN 083 THEN insert into summary.daily083 VALUES (NEW.*);
WHEN 084 THEN insert into summary.daily084 VALUES (NEW.*);
WHEN 085 THEN insert into summary.daily085 VALUES (NEW.*);
WHEN 086 THEN insert into summary.daily086 VALUES (NEW.*);
WHEN 087 THEN insert into summary.daily087 VALUES (NEW.*);
WHEN 088 THEN insert into summary.daily088 VALUES (NEW.*);
WHEN 089 THEN insert into summary.daily089 VALUES (NEW.*);
WHEN 090 THEN insert into summary.daily090 VALUES (NEW.*);
WHEN 091 THEN insert into summary.daily091 VALUES (NEW.*);
WHEN 092 THEN insert into summary.daily092 VALUES (NEW.*);
WHEN 093 THEN insert into summary.daily093 VALUES (NEW.*);
WHEN 094 THEN insert into summary.daily094 VALUES (NEW.*);
WHEN 095 THEN insert into summary.daily095 VALUES (NEW.*);
WHEN 096 THEN insert into summary.daily096 VALUES (NEW.*);
WHEN 097 THEN insert into summary.daily097 VALUES (NEW.*);
WHEN 098 THEN insert into summary.daily098 VALUES (NEW.*);
WHEN 099 THEN insert into summary.daily099 VALUES (NEW.*);
WHEN 100 THEN insert into summary.daily100 VALUES (NEW.*);
WHEN 101 THEN insert into summary.daily101 VALUES (NEW.*);
WHEN 102 THEN insert into summary.daily102 VALUES (NEW.*);
WHEN 103 THEN insert into summary.daily103 VALUES (NEW.*);
WHEN 104 THEN insert into summary.daily104 VALUES (NEW.*);
WHEN 105 THEN insert into summary.daily105 VALUES (NEW.*);
WHEN 106 THEN insert into summary.daily106 VALUES (NEW.*);
WHEN 107 THEN insert into summary.daily107 VALUES (NEW.*);
WHEN 108 THEN insert into summary.daily108 VALUES (NEW.*);
WHEN 109 THEN insert into summary.daily109 VALUES (NEW.*);
WHEN 110 THEN insert into summary.daily110 VALUES (NEW.*);
WHEN 111 THEN insert into summary.daily111 VALUES (NEW.*);
WHEN 112 THEN insert into summary.daily112 VALUES (NEW.*);
WHEN 113 THEN insert into summary.daily113 VALUES (NEW.*);
WHEN 114 THEN insert into summary.daily114 VALUES (NEW.*);
WHEN 115 THEN insert into summary.daily115 VALUES (NEW.*);
WHEN 116 THEN insert into summary.daily116 VALUES (NEW.*);
WHEN 117 THEN insert into summary.daily117 VALUES (NEW.*);
WHEN 118 THEN insert into summary.daily118 VALUES (NEW.*);
WHEN 119 THEN insert into summary.daily119 VALUES (NEW.*);
WHEN 120 THEN insert into summary.daily120 VALUES (NEW.*);
WHEN 121 THEN insert into summary.daily121 VALUES (NEW.*);
WHEN 122 THEN insert into summary.daily122 VALUES (NEW.*);
WHEN 123 THEN insert into summary.daily123 VALUES (NEW.*);
WHEN 124 THEN insert into summary.daily124 VALUES (NEW.*);
WHEN 125 THEN insert into summary.daily125 VALUES (NEW.*);
WHEN 126 THEN insert into summary.daily126 VALUES (NEW.*);
WHEN 127 THEN insert into summary.daily127 VALUES (NEW.*);
WHEN 128 THEN insert into summary.daily128 VALUES (NEW.*);
WHEN 129 THEN insert into summary.daily129 VALUES (NEW.*);
WHEN 130 THEN insert into summary.daily130 VALUES (NEW.*);
WHEN 131 THEN insert into summary.daily131 VALUES (NEW.*);
WHEN 132 THEN insert into summary.daily132 VALUES (NEW.*);
WHEN 133 THEN insert into summary.daily133 VALUES (NEW.*);
WHEN 134 THEN insert into summary.daily134 VALUES (NEW.*);
WHEN 135 THEN insert into summary.daily135 VALUES (NEW.*);
WHEN 136 THEN insert into summary.daily136 VALUES (NEW.*);
WHEN 137 THEN insert into summary.daily137 VALUES (NEW.*);
WHEN 138 THEN insert into summary.daily138 VALUES (NEW.*);
WHEN 139 THEN insert into summary.daily139 VALUES (NEW.*);
WHEN 140 THEN insert into summary.daily140 VALUES (NEW.*);
WHEN 141 THEN insert into summary.daily141 VALUES (NEW.*);
WHEN 142 THEN insert into summary.daily142 VALUES (NEW.*);
WHEN 143 THEN insert into summary.daily143 VALUES (NEW.*);
WHEN 144 THEN insert into summary.daily144 VALUES (NEW.*);
WHEN 145 THEN insert into summary.daily145 VALUES (NEW.*);
WHEN 146 THEN insert into summary.daily146 VALUES (NEW.*);
WHEN 147 THEN insert into summary.daily147 VALUES (NEW.*);
WHEN 148 THEN insert into summary.daily148 VALUES (NEW.*);
WHEN 149 THEN insert into summary.daily149 VALUES (NEW.*);
WHEN 150 THEN insert into summary.daily150 VALUES (NEW.*);
WHEN 151 THEN insert into summary.daily151 VALUES (NEW.*);
WHEN 152 THEN insert into summary.daily152 VALUES (NEW.*);
WHEN 153 THEN insert into summary.daily153 VALUES (NEW.*);
WHEN 154 THEN insert into summary.daily154 VALUES (NEW.*);
WHEN 155 THEN insert into summary.daily155 VALUES (NEW.*);
WHEN 156 THEN insert into summary.daily156 VALUES (NEW.*);
WHEN 157 THEN insert into summary.daily157 VALUES (NEW.*);
WHEN 158 THEN insert into summary.daily158 VALUES (NEW.*);
WHEN 159 THEN insert into summary.daily159 VALUES (NEW.*);
WHEN 160 THEN insert into summary.daily160 VALUES (NEW.*);
WHEN 161 THEN insert into summary.daily161 VALUES (NEW.*);
WHEN 162 THEN insert into summary.daily162 VALUES (NEW.*);
WHEN 163 THEN insert into summary.daily163 VALUES (NEW.*);
WHEN 164 THEN insert into summary.daily164 VALUES (NEW.*);
WHEN 165 THEN insert into summary.daily165 VALUES (NEW.*);
WHEN 166 THEN insert into summary.daily166 VALUES (NEW.*);
WHEN 167 THEN insert into summary.daily167 VALUES (NEW.*);
WHEN 168 THEN insert into summary.daily168 VALUES (NEW.*);
WHEN 169 THEN insert into summary.daily169 VALUES (NEW.*);
WHEN 170 THEN insert into summary.daily170 VALUES (NEW.*);
WHEN 171 THEN insert into summary.daily171 VALUES (NEW.*);
WHEN 172 THEN insert into summary.daily172 VALUES (NEW.*);
WHEN 173 THEN insert into summary.daily173 VALUES (NEW.*);
WHEN 174 THEN insert into summary.daily174 VALUES (NEW.*);
WHEN 175 THEN insert into summary.daily175 VALUES (NEW.*);
WHEN 176 THEN insert into summary.daily176 VALUES (NEW.*);
WHEN 177 THEN insert into summary.daily177 VALUES (NEW.*);
WHEN 178 THEN insert into summary.daily178 VALUES (NEW.*);
WHEN 179 THEN insert into summary.daily179 VALUES (NEW.*);
WHEN 180 THEN insert into summary.daily180 VALUES (NEW.*);
WHEN 181 THEN insert into summary.daily181 VALUES (NEW.*);
WHEN 182 THEN insert into summary.daily182 VALUES (NEW.*);
WHEN 183 THEN insert into summary.daily183 VALUES (NEW.*);
WHEN 184 THEN insert into summary.daily184 VALUES (NEW.*);
WHEN 185 THEN insert into summary.daily185 VALUES (NEW.*);
WHEN 186 THEN insert into summary.daily186 VALUES (NEW.*);
WHEN 187 THEN insert into summary.daily187 VALUES (NEW.*);
WHEN 188 THEN insert into summary.daily188 VALUES (NEW.*);
WHEN 189 THEN insert into summary.daily189 VALUES (NEW.*);
WHEN 190 THEN insert into summary.daily190 VALUES (NEW.*);
WHEN 191 THEN insert into summary.daily191 VALUES (NEW.*);
WHEN 192 THEN insert into summary.daily192 VALUES (NEW.*);
WHEN 193 THEN insert into summary.daily193 VALUES (NEW.*);
WHEN 194 THEN insert into summary.daily194 VALUES (NEW.*);
WHEN 195 THEN insert into summary.daily195 VALUES (NEW.*);
WHEN 196 THEN insert into summary.daily196 VALUES (NEW.*);
WHEN 197 THEN insert into summary.daily197 VALUES (NEW.*);
WHEN 198 THEN insert into summary.daily198 VALUES (NEW.*);
WHEN 199 THEN insert into summary.daily199 VALUES (NEW.*);
WHEN 200 THEN insert into summary.daily200 VALUES (NEW.*);
WHEN 201 THEN insert into summary.daily201 VALUES (NEW.*);
WHEN 202 THEN insert into summary.daily202 VALUES (NEW.*);
WHEN 203 THEN insert into summary.daily203 VALUES (NEW.*);
WHEN 204 THEN insert into summary.daily204 VALUES (NEW.*);
WHEN 205 THEN insert into summary.daily205 VALUES (NEW.*);
WHEN 206 THEN insert into summary.daily206 VALUES (NEW.*);
WHEN 207 THEN insert into summary.daily207 VALUES (NEW.*);
WHEN 208 THEN insert into summary.daily208 VALUES (NEW.*);
WHEN 209 THEN insert into summary.daily209 VALUES (NEW.*);
WHEN 210 THEN insert into summary.daily210 VALUES (NEW.*);
WHEN 211 THEN insert into summary.daily211 VALUES (NEW.*);
WHEN 212 THEN insert into summary.daily212 VALUES (NEW.*);
WHEN 213 THEN insert into summary.daily213 VALUES (NEW.*);
WHEN 214 THEN insert into summary.daily214 VALUES (NEW.*);
WHEN 215 THEN insert into summary.daily215 VALUES (NEW.*);
WHEN 216 THEN insert into summary.daily216 VALUES (NEW.*);
WHEN 217 THEN insert into summary.daily217 VALUES (NEW.*);
WHEN 218 THEN insert into summary.daily218 VALUES (NEW.*);
WHEN 219 THEN insert into summary.daily219 VALUES (NEW.*);
WHEN 220 THEN insert into summary.daily220 VALUES (NEW.*);
WHEN 221 THEN insert into summary.daily221 VALUES (NEW.*);
WHEN 222 THEN insert into summary.daily222 VALUES (NEW.*);
WHEN 223 THEN insert into summary.daily223 VALUES (NEW.*);
WHEN 224 THEN insert into summary.daily224 VALUES (NEW.*);
WHEN 225 THEN insert into summary.daily225 VALUES (NEW.*);
WHEN 226 THEN insert into summary.daily226 VALUES (NEW.*);
WHEN 227 THEN insert into summary.daily227 VALUES (NEW.*);
WHEN 228 THEN insert into summary.daily228 VALUES (NEW.*);
WHEN 229 THEN insert into summary.daily229 VALUES (NEW.*);
WHEN 230 THEN insert into summary.daily230 VALUES (NEW.*);
WHEN 231 THEN insert into summary.daily231 VALUES (NEW.*);
WHEN 232 THEN insert into summary.daily232 VALUES (NEW.*);
WHEN 233 THEN insert into summary.daily233 VALUES (NEW.*);
WHEN 234 THEN insert into summary.daily234 VALUES (NEW.*);
WHEN 235 THEN insert into summary.daily235 VALUES (NEW.*);
WHEN 236 THEN insert into summary.daily236 VALUES (NEW.*);
WHEN 237 THEN insert into summary.daily237 VALUES (NEW.*);
WHEN 238 THEN insert into summary.daily238 VALUES (NEW.*);
WHEN 239 THEN insert into summary.daily239 VALUES (NEW.*);
WHEN 240 THEN insert into summary.daily240 VALUES (NEW.*);
WHEN 241 THEN insert into summary.daily241 VALUES (NEW.*);
WHEN 242 THEN insert into summary.daily242 VALUES (NEW.*);
WHEN 243 THEN insert into summary.daily243 VALUES (NEW.*);
WHEN 244 THEN insert into summary.daily244 VALUES (NEW.*);
WHEN 245 THEN insert into summary.daily245 VALUES (NEW.*);
WHEN 246 THEN insert into summary.daily246 VALUES (NEW.*);
WHEN 247 THEN insert into summary.daily247 VALUES (NEW.*);
WHEN 248 THEN insert into summary.daily248 VALUES (NEW.*);
WHEN 249 THEN insert into summary.daily249 VALUES (NEW.*);
WHEN 250 THEN insert into summary.daily250 VALUES (NEW.*);
WHEN 251 THEN insert into summary.daily251 VALUES (NEW.*);
WHEN 252 THEN insert into summary.daily252 VALUES (NEW.*);
WHEN 253 THEN insert into summary.daily253 VALUES (NEW.*);
WHEN 254 THEN insert into summary.daily254 VALUES (NEW.*);
WHEN 255 THEN insert into summary.daily255 VALUES (NEW.*);
WHEN 256 THEN insert into summary.daily256 VALUES (NEW.*);
WHEN 257 THEN insert into summary.daily257 VALUES (NEW.*);
WHEN 258 THEN insert into summary.daily258 VALUES (NEW.*);
WHEN 259 THEN insert into summary.daily259 VALUES (NEW.*);
WHEN 260 THEN insert into summary.daily260 VALUES (NEW.*);
WHEN 261 THEN insert into summary.daily261 VALUES (NEW.*);
WHEN 262 THEN insert into summary.daily262 VALUES (NEW.*);
WHEN 263 THEN insert into summary.daily263 VALUES (NEW.*);
WHEN 264 THEN insert into summary.daily264 VALUES (NEW.*);
WHEN 265 THEN insert into summary.daily265 VALUES (NEW.*);
WHEN 266 THEN insert into summary.daily266 VALUES (NEW.*);
WHEN 267 THEN insert into summary.daily267 VALUES (NEW.*);
WHEN 268 THEN insert into summary.daily268 VALUES (NEW.*);
WHEN 269 THEN insert into summary.daily269 VALUES (NEW.*);
WHEN 270 THEN insert into summary.daily270 VALUES (NEW.*);
WHEN 271 THEN insert into summary.daily271 VALUES (NEW.*);
WHEN 272 THEN insert into summary.daily272 VALUES (NEW.*);
WHEN 273 THEN insert into summary.daily273 VALUES (NEW.*);
WHEN 274 THEN insert into summary.daily274 VALUES (NEW.*);
WHEN 275 THEN insert into summary.daily275 VALUES (NEW.*);
WHEN 276 THEN insert into summary.daily276 VALUES (NEW.*);
WHEN 277 THEN insert into summary.daily277 VALUES (NEW.*);
WHEN 278 THEN insert into summary.daily278 VALUES (NEW.*);
WHEN 279 THEN insert into summary.daily279 VALUES (NEW.*);
WHEN 280 THEN insert into summary.daily280 VALUES (NEW.*);
WHEN 281 THEN insert into summary.daily281 VALUES (NEW.*);
WHEN 282 THEN insert into summary.daily282 VALUES (NEW.*);
WHEN 283 THEN insert into summary.daily283 VALUES (NEW.*);
WHEN 284 THEN insert into summary.daily284 VALUES (NEW.*);
WHEN 285 THEN insert into summary.daily285 VALUES (NEW.*);
WHEN 286 THEN insert into summary.daily286 VALUES (NEW.*);
WHEN 287 THEN insert into summary.daily287 VALUES (NEW.*);
WHEN 288 THEN insert into summary.daily288 VALUES (NEW.*);
WHEN 289 THEN insert into summary.daily289 VALUES (NEW.*);
WHEN 290 THEN insert into summary.daily290 VALUES (NEW.*);
WHEN 291 THEN insert into summary.daily291 VALUES (NEW.*);
WHEN 292 THEN insert into summary.daily292 VALUES (NEW.*);
WHEN 293 THEN insert into summary.daily293 VALUES (NEW.*);
WHEN 294 THEN insert into summary.daily294 VALUES (NEW.*);
WHEN 295 THEN insert into summary.daily295 VALUES (NEW.*);
WHEN 296 THEN insert into summary.daily296 VALUES (NEW.*);
WHEN 297 THEN insert into summary.daily297 VALUES (NEW.*);
WHEN 298 THEN insert into summary.daily298 VALUES (NEW.*);
WHEN 299 THEN insert into summary.daily299 VALUES (NEW.*);
ELSE insert into summary.daily VALUES (NEW.*);
END CASE;
RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER insert_daily_trigger
BEFORE INSERT ON summary.daily FOR EACH ROW 
EXECUTE PROCEDURE daily_insert_trigger();

END;