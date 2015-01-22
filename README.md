# JHCocoaJsonMap
一个mac for ios的命令行程序（能把json 映射成model class 的代码文件，减少大家平日解析json 的工作量），生成的代码支持mac os 以及ios 上运行  

#开发当前功能的原因：
   过去开发iOS的时候，在解析json 的时候，由于iOS 没有映射机制，所以大家都经常将json data 转化成NSDictonary 或者NSArray 来访问，虽然快捷方便， 但对于检校数据的正确性以及程序稳定性来讲，却是一个很大的考验。例如如果一旦服务器修改了一个字段，而且自己没有及时跟进的话，问题就有可能变得严重了。    
   所以我一开始的活就是把json data  映射成一个model class！，然后自己编写了一个JSONParser做自动解析。这么多年来，由于工作的繁忙，又加上知道网上已经涌现出很多类似解决方案的优秀框架，例如JSONModel，MJExtension等，所以我也没想把自己比较烦的代码发布上去了。    
   最近，由于一个项目的关系， 要解析的json 达到100多个，虽然使用映射的框架而不用再写解析流程的确能节省了大量的工作时间，但要自己手工添加.h .m 文件也够自己忙几天了。相信，大家应该也遇过这类的问题，而且也好像没有人关注这一方面；很多iOS 达人，很拒绝在ios上使用映射机制去访问json，也是因为需要自己手动添加模型文件，觉得麻烦而拒绝使用这一优秀的做法。当然，开发java .net 的达人们，没有这方面的苦恼，因为他们的ide 都有提供了如此功能。    
   那么问题来了，我们能否有一种快捷的方式，免去编写h文件，m文件的苦恼呢？ 最近本人有点闲，所以整理了这个思路，开发了如下的插件，不知道能否为大家日后繁忙的开发中，减低一点点的工作量呢？    
   该项目是一个命令行输出程序，运行在MAC OS上，主要功能就是能够根据json 的数据，生成模型的代码文件，项目也提供了JSONParser类， 实现了读取这些json 数据，能够相应返回指定的类！  

#项目说明：
JHCocoa 项目  
  JHCocoa： 命令行输出程序，主要功能就是通过配置json 文件，生成对应的模型类文件出来；  
  JSONLibrary： json 数据解析文件， 当生成对应的模型类文件后， 可以使用当前库 把对应的json 数据解析成模型类。  

JHCocoaDemo 示例项目：  
JHCocoaCreateDemo：  通过配置json 文件，生成对应的模型类文件 的示例配置；  
   JHCocoa：编译好的二进制命令行程序；  
   JHCocoa.json  配置文件，需要映射的json 的存放数据，下面会有注释；  
   JHCocoa_resource  一些示例的json 文件  
JHCocoaParserDemo：  简单的测试项目。  

示例项目使用指南：  
1,打开终端，执行命令：cd {你的项目目录}/JHCocoaDemo/JHCocoaCreateDemo/    
2,执行命令：./JHCocoa -version,   可以查看版本号    
3，执行命令：./JHCocoa -update      
4，当前目录里会生成目录model  以及目录parser    
    
示例：    
{    
    "testString": "Hello World",     
    "testInt": 550,     
    "testFloat": 43.994,    
    "testDouble": 98000.4455566544,     
    "testLongLong": 13432323401    
}    
将在model 目录中生成对应的代码：        
    
@interface TestClassModel : NSObject        
@property(nonatomic,assign) long long testInt;        
@property(nonatomic,assign) double testFloat;       
@property(nonatomic,strong) NSString* testString;       
@property(nonatomic,assign) double testDouble;       
@property(nonatomic,assign) long long testLongLong;       
@end              



    
model 目录：  存放对应的json 的模型类文件    
parser 目录： 生成一个JHCocoaParser 类， 生成解析模型的代码，方便快速调用。  

当执行完以上操作后， 打开JHCocoaParserDemo.xcodeproj 工程，工程里的main.m 文件，详细地介绍了如何通过映射的方式，把son data 转化成刚刚生成的Map 模型类。  
    
#JHCocoa.json文件解说：
类似下列的结构  
{  
    "ASIHTTPRequest": true,          
    "url_map_model": [  
                      {  
                      "map_url": "JHCocoa_resource/classWithClass.json",  
                      "moduleName": "TestClassWithClassModel"  
                      "method": "get"  
                      },  
                     ……  
                      ]  
}  
    
ASIHTTPRequest 属性：  暂未有用  
url_map_model 属性：  要转换的son data 的集合  
map_url  属性：  指定要转换的son data 的文件路径，暂只能为相对路径，可以为http 或者ftp  
moduleName  属性： 指定要为json data 生成的对应模型类名  
method  属性：如果map_url 为http 访问， method 就决定是使用get 方法还是post 方法，默认为get  
    
#JSONParser 用法

当有一段json data ，然后又生成了对应的模型类后，
可以调用以下方法：    

JSONParser* parser=[[JSONParser alloc] init];    
parser.serialModelName=@“模型的类名”;    
[parser parse:data];    
return parser.result;      
    
由于本人比较懒， 暂没有直接图文讲解，对此十分抱歉， 对于该项目， 我有很多的想法，想做得更便捷，但无奈星火有限，类似能够包含NSCoding or NSCopy， 以及快速生成对应http asihttprequest or afnetworking 之类的应用，我实在无瑕照顾，  更何况还妄想一键生成，嵌入xcodeproj 项目里，实现到类似cocoa pod！ 如果有朋友觉得该项目有价值，能抽空完善不足的地方，实在感激万分！



