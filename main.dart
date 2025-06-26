import 'package:flutter/material.dart';
import 'package:notes/DB/notes_db.dart';

 
void main() async {
 // WidgetsFlutterBinding.ensureInitialized(); // ✅ Important for async plugin init
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  //controllers
  TextEditingController titleController = TextEditingController() ;
  TextEditingController descriptionController = TextEditingController() ;



  List < Map < String,dynamic > > allNotes = [] ;
  NotesDb? dbRef ;

  @override
  void initState() {
  
   super.initState();
   dbRef = NotesDb.getInstance ;
   getNotes() ;

  }

void getNotes()async{

 allNotes = await dbRef!.readNotes() ;

 setState(() {
   
 });

} 


  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'notes app',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      home:  Scaffold(

        appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Notes' , style: TextStyle(fontSize: 28 , fontWeight: FontWeight.w500,color: Colors.black),),
        centerTitle: true,

      ),

   

      //all notes viewed here

      body: allNotes.isNotEmpty ?  ListView.builder(

        itemCount: allNotes.length,
        
        itemBuilder: ( _, index) {
          return ListTile(
            leading: Text('${ allNotes[index][NotesDb.Column_SR_NO] }'),

            title: Text(allNotes[index][NotesDb.Column_Title]),

            subtitle: Text(allNotes[index][NotesDb.Column_Description]),

            trailing: SizedBox(
              width: 50,
              child: Row(
                children: [
                  Builder(
                    builder: (context) {
                      return InkWell( onTap: (){

                        titleController.text = allNotes[index][NotesDb.Column_Title] ;
                        descriptionController.text = allNotes[index][NotesDb.Column_Description] ;

                        
                      
                             showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                      
                                  padding: EdgeInsets.all(11),
                                  width: double.infinity,
                      
                                  child: Column(
                                    
                                    children: [
                                      
                      
                                      Text("Update Note" , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold),) ,
                      
                                      SizedBox(height: 21,) ,
                      
                      
                                      TextField(
                      
                      controller: titleController,
                      
                      decoration: InputDecoration(
                         floatingLabelBehavior: FloatingLabelBehavior.always ,
                         
                        hintText: "Enter title here" ,
                        label: Text('Title') ,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11) 
                        ) ,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)
                        )
                      
                      ),
                                      ) ,
                      
                      SizedBox(height: 21,) ,
                      
                      
                                      TextField(
                      
                      controller: descriptionController,
                      maxLines: 1,
                      
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always ,
                      //  alignLabelWithHint: true,
                        
                        
                        hintText: "Enter description here" ,
                        label: Text('Description') ,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11) 
                        ) ,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)
                        )
                      
                      ),
                                      ) ,
                                       SizedBox(height: 21,) ,
                      
                                       Row(
                      children: [
                      
                        Expanded(child: OutlinedButton(
                          style: OutlinedButton.styleFrom(side:  BorderSide(width: 1.2))
                          ,onPressed: ()async{
                      
                            var mtitle = titleController.text ;
                            var mdescription = descriptionController.text ;
                      
                            if(mtitle.isNotEmpty && mdescription.isNotEmpty){
                      
                             bool check = await dbRef!.updateNotes(title: mtitle, description: mdescription, sr_no: allNotes[index][NotesDb.Column_SR_NO]) ;
                                
                                if(check){
                                  getNotes() ;
                                }
                      
                            } else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: Text("please fill all the required things..")))) ;
                                }
                                
                                titleController.clear() ;
                                descriptionController.clear() ;
                             
                            
                      
                                Navigator.pop(context) ;
                      
                          }
                          , child: Text("Update Note"))) ,
                      
                        SizedBox(width: 21,) ,
                      
                        Expanded(child: OutlinedButton(style: OutlinedButton.styleFrom(side:  BorderSide(width: 1.2)) ,
                        onPressed: (){
                      
                         
                      
                           titleController.clear() ;
                           descriptionController.clear() ;

                            Navigator.pop(context) ;
                      
                        }, child: Text("Cancel"),

                        )
                        ) ,
                        
                      ],
                                       )
                      
                      
                                    ],
                                  ),
                                ) ;
                              },
                            );
                      },child: Icon(Icons.edit));
                    }
                  ) ,
                  
                  InkWell(onTap:(){} ,child: Icon(Icons.delete , color: Colors.red,))
                ],
              ),
            ),
          ) ;

      })

      :  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notes_outlined ,
            size: 80,
            color: Colors.grey[600],) ,

            SizedBox(height: 20,),

            Text('No Notes Found', style: TextStyle(
              color: Colors.grey[400] ,fontWeight: FontWeight.w500 , fontSize: 20
            ),)


          ],
        ),

        
      ),
 floatingActionButton: Builder(
  builder: (context) => FloatingActionButton(
    onPressed: () async {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(

            padding: EdgeInsets.all(11),
            width: double.infinity,

            child: Column(
              
              children: [
                

                Text("Add Note" , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold),) ,

                SizedBox(height: 21,) ,


                TextField(

                  controller: titleController,

                  decoration: InputDecoration(
                     floatingLabelBehavior: FloatingLabelBehavior.always ,
                     
                    hintText: "Enter title here" ,
                    label: Text('Title') ,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11) 
                    ) ,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)
                    )

                  ),
                ) ,

                  SizedBox(height: 21,) ,


                TextField(

                  controller: descriptionController,
                  maxLines: 1,

                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always ,
                  //  alignLabelWithHint: true,
                    
                    
                    hintText: "Enter description here" ,
                    label: Text('Description') ,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11) 
                    ) ,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)
                    )

                  ),
                ) ,
                 SizedBox(height: 21,) ,

                 Row(
                  children: [

                    Expanded(child: OutlinedButton(
                      style: OutlinedButton.styleFrom(side:  BorderSide(width: 1.2))
                      ,onPressed: ()async{

                        var mtitle = titleController.text ;
                        var mdescription = descriptionController.text ;

                        if(mtitle.isNotEmpty && mdescription.isNotEmpty){

                         bool check = await dbRef!.addNotes(title: mtitle, description: mdescription) ;
                            
                            if(check){
                              getNotes() ;
                            }

                        } else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: Text("please fill all the required things..")))) ;
                            }
                            
                            titleController.clear() ;
                            descriptionController.clear() ;
                         
                        

                            Navigator.pop(context) ;

                      }
                      , child: Text("Add Note"))) ,

                    SizedBox(width: 21,) ,

                    Expanded(child: OutlinedButton(style: OutlinedButton.styleFrom(side:  BorderSide(width: 1.2)) ,
                    onPressed: (){

                      Navigator.pop(context) ;

                       titleController.clear() ;
                       descriptionController.clear() ;

                    }, child: Text("Cancel"))) ,
                    
                  ],
                 )


              ],
            ),
          ) ;
        },
      );
    },
    backgroundColor: Colors.white,
    child: const Icon(Icons.add, color: Colors.black87),
  ),
),





      ),
    ) ;
  }
}