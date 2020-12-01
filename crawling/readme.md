## [종류]

|앞글자|내용|
|:------:|:---:|
|A|국내 주식(A제외 하고 코드만 입력필)|
|CA|캐나다 주|
|CNE|중국 주|
|...|해외 주|
|US|미국 주|
|Q|증권|
|J|증권|

## [분류기준]
대표적 분류기준 중 국제표준기준은 WICS이다.
http://www.wiseindex.com/About/WICS

## [크롤링 내용]
아래의 사이트에서 크롤링이 가능하며, kr.investing을 활용할 것이다.
- https://www.marketscreener.com/: 단점 - 유료
- https://kr.investing.com/
- 네이버 금융은 국내 주 검색 위주이며, 이를 보완하기 위해 네이버 증권(m.stock.naver)을 이용해도 된다.

## [크롤링 프로세스]
1) (코드) https://kr.investing.com/search/?q=353200 (q='코드' 형태이며, 이 때 A로 시작하는 국내 주는 이를 제외하고 입력해야한다.)
2) (클릭) 모든 결과 -> 시세 -> 상단에 있는 기업 클릭 https://kr.investing.com/equities/daeduck-electronics
3) (코드) 종류 : 주식을 먼저 크롤링한다.(증권도 존재하기 때문이다.)
4) (코드) 산업, 부문을 다음 URL에서 크롤링한다. https://kr.investing.com/equities/daeduck-electronics-company-profile
