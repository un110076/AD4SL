from test01 import *

x=[1.0]
y=[0.0]
a_y=[1.0]
a_x=[0.0]
a_x=a_test01(x,a_x,y,a_y)
print(a_x);

y=[0.0]
y=test01(x,y)
x[0]+=1e-4
yp=[0.0]
yp=test01(x,yp)
print((yp[0]-y[0])/1e-4)

from test02 import *

x=[1.0]
y=[0.0]
a_y=[1.0]
a_x=[0.0]
a_x=a_test02(x,a_x,y,a_y)
print(a_x);

y=[0.0]
y=test02(x,y)
x[0]+=1e-4
yp=[0.0]
yp=test02(x,yp)
print((yp[0]-y[0])/1e-4)

from test03 import *

x=[1.0]
y=[0.0]
a_y=[1.0]
a_x=[0.0]
a_x=a_test03(x,a_x,y,a_y)
print(a_x);

y=[0.0]
y=test03(x,y)
x[0]+=1e-4
yp=[0.0]
yp=test03(x,yp)
print((yp[0]-y[0])/1e-4)


