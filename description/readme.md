[DATA] <br>
CUS_INFO
|컬럼명|내용|형태|
|:------:|:---:|:---:|
|CUS_ID|고객번호|숫자|
|SEX_DIT_CD|성별|범주|
|CUS_AGE|연령대|범주|
|ZIP_CTP_CD|주소(시도)|범주|
|TCO_CUS_GRD_CD|고객등급|범주|
|IVS_ICN_CD|고객투자성향|범주|

ACT_INFO
|컬럼명|내용|형태|
|:------:|:---:|:---:|
|ACT_ID|계좌번호|숫자|
|CUS_ID|고객번호|숫자|
|ACT_OPN_YM|계좌개설월|날짜|

IEM_INFO
|컬럼명|내용|형태|
|:------:|:---:|:---:|
|IEM_CD|종목코드|문자(코드)|
|IEM_ENG_NM|종목영문명|문자|
|IEM_KRL_NM|종목한글명|문자|

TRD_KR(국내거래)
|컬럼명|내용|형태|
|:------:|:---:|:---:|
|ACT_ID|계좌번호|숫자|
|ORR_DT|주문날짜|날짜|
|ORR_ORD|주문순서|숫자|
|ORR_RTN_HUR|주문접수시간대|숫자|
|LST_CNS_HUR|최종체결시간대|숫자|
|IEM_CD|종목코드|문자(코드)|
|SBY_DIT_CD|매매구분코드|범주|
|CNS_QTY|체결수량|숫자|
|ORR_PR|체결가격|숫자|
|ORR_MDI_DIT_CD|주문매체구분코드|범주|

TRD_OSS(해외거래)
|컬럼명|내용|형태|
|:------:|:---:|:---:|
|ACT_ID|계좌번호|숫자|
|ORR_DT|주문날짜|날짜|
|ORR_ORD|주문순서|숫자|
|ORR_RTN_HUR|주문접수시간대|숫자|
|LST_CNS_HUR|최종체결시간대|숫자|
|IEM_CD|종목코드|문자(코드)|
|SBY_DIT_CD|매매구분코드|범주|
|CNS_QTY|체결수량|숫자|
|ORR_PR|체결가격|숫자|
|ORR_MDI_DIT_CD|주문매체구분코드|범주|
|CUR_CD|거래통화코드|문자|
|TRD_CUR_XCG_RT|거래통화환율|숫자|
