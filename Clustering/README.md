# Clustering

개체 유도 기법에는 군집분석과 판별분석이 있다. <br>
군집분석(Clustering)은 군을 모르는 상태에서 군을 나눠주는 방식이고, <br>
판별분석(Discriminant analysis)은 군을 알고있는 상태에서 군을 나누는 기준(판별함수)를 발견해, 새로운 대상의 집단분류를 돕는다.

(군집분석) https://gyeongdeok.netlify.app/2020/11/25/clustering/ <br>
(판별분석) https://gyeongdeok.netlify.app/2020/11/27/lda/ 

1. 군집분석 <br>
 기본적으로 데이터 포인트들의 거리를 계산한 매트릭스 D를 이용하여 군집분석을 진행한다. <br>
 범주형 변수의 경우에 거리의 개념이 정의되지 않으므로, 분석에서 제외한다. <br>
 보통 군집분석을 진행하는 경우 각 군의 특성을 설명하기 위해 차원 축소를 한 후에 군집분석을 진행하는 것이 설명력이 좋다. 설명력을 위해 2,3차원으로 데이터의 차원을 줄인 후에 군집분석을 진행하자. 그렇지 않으면 기존 데이터로 군집분석을 진행한 후에 산점도 행렬을 통해 규칙을 찾아보는 것도 좋은 듯 하다.
 
- 계층적 군집분석<br>
 가장 가까이에 있는 대상들을 묶으면서 나무 모양의 계층 구조를 형성한다. <br>
 가까이 있는 대상들을 묶는 방식이 있다. 최단거리, 최장거리, 평균거리, 중심거리 등의 방법이 있다. <br>
 
 경덕피셜) 가까운 거리에 있는 군들이 어떻게 묶인건지, 산점도를 분류해가면서 하나씩 그려보면서 규칙을 찾아야 할 듯 하다. <br>
 (시각화가 잘되어 있는 사이트) https://joyfuls.tistory.com/64 <br>
 (정리잘 된 강의자료) <br> http://wolfpack.hnu.ac.kr/lecture/Fall2007/%EB%8B%A4%EB%B3%80%EB%9F%89%EB%B6%84%EC%84%9D/MDA%20CA%2011192007.pdf
 
 - 비계층적 군집분석<br> 
  (1) 프로토타입 군집분석<br>
   군집을 대표하는 데이터 하나를 기준으로 유사하 데이터를 묶어서 군집을 형성한다. <br>
   가장 유명한 K-means clustering. 방식이 있다. 아웃라이어에 취약한 데이터는 K-medoids clustering을 이용해도 된다.<br>
 
  (2) 분포기반 군집분석은 각 군집은 '특정 확률분포에 따라 형성된다'라는 가정이 있으며, GMM이 대표적이다.<br>
  (3) 밀도기반 군집분석은 동일 군집의 데이터들은 서로 위치가 비슷(밀도가 높다)하다라는 가정이 있으며, DBSCAN이 대표적이다.
 
 (종류에 대해 분류를 잘해둔 사이트)<br> https://blog.naver.com/PostView.nhn?blogId=winddori2002&logNo=221894208971&parentCategoryNo=1&categoryNo=&viewDate=&isShowPopularPosts=false&from=postView <br>
 (정리 훌륭 강의자료) <br>http://wolfpack.hannam.ac.kr/Stat_Notes/adv_stat/MDA/MDA_%ED%8C%90%EB%B3%84%EB%B6%84%EC%84%9D.pdf
 
 2. 판별분석 <br>
  이미 군이 나눠져 있는 데이터에 대해 적용하는 방식이다. 라벨링 된 데이터에 대해 군을 구별하는 판별함수를 찾아 새로운 데이터 포인트의 위치를 파악하는 방식이다.
  ex) LDA
