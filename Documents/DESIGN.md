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

struct Plant: Codable {
    var id: String!
    var name: String!
    var location: String!
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "NAAM"
        case location = "LOCATIE"
    }
}

struct PH: Firebase {
    var Plant ID: String!
        var PH: int?
        var datum: int?
}

idem voor growth, yield & comments 


enum PhGrade {
    case 0
    case 1
    case 2
    case 3
    ...
    case 14
}

**Functions**
signIn()
selectData()
inputData()
showPH()
showGrowth()
showYield()
showComments()


**API**
Firebase
