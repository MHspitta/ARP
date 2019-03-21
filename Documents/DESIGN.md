**Classes**

SignUpViewController --> UIViewController
ARSceneViewController --> UIViewController, ARSCNViewDelegate
ChooseDataViewController --> UIViewController
InputDataViewController --> UIViewController
PhotoViewController --> UIViewController

**Structs**

struct User {
  var username: String
  var password: String
}

struct Plant {
  var ph: Int
  var growth: Int?
  var yield: Int
  var comments: String
}

struct Datacard {
  var ph: Int
  var growth: Int
  var yield: Int
  var comments: String
}

**Functions**
signIn()
selectData()
inputData()

**API**
Firebase
