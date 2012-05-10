void AEkeysMain() {
  for (int i=0;i<numParticles;i++) {
    data.add("\t" + "var solid = myComp.layers.addSolid([1.0, 1.0, 0], \"my square\", 50, 50, 1);" + "\r");
    if(motionBlur){
      data.add("\t" + "solid.motionBlur = true;" + "\r");
    }
    if(applyEffects){
      AEeffects();
    }
    data.add("\r");
    data.add("\t" + "var p = solid.property(\"position\");" + "\r");
    data.add("\t" + "var r = solid.property(\"rotation\");" + "\r");
    data.add("\r");

    for (int j=0;j<counterMax;j++) {
      if(applySmoothing){  //this doesn't really work right now
      if(j==0||j==counterMax-1){
        AEkeyPos(i,j);
      }else{
         if(hitDetect(particle[i].AEpath[j].x,particle[i].AEpath[j].y,1,1,particle[i].AEpath[j-1].x,particle[i].AEpath[j-1].x,smoothNum,smoothNum)){ 
           AEkeyPos(i,j);
         }
      }
    }else{
      AEkeyPos(i,j);
    }
  }
}
}

void AEkeyPos(int spriteNum, int frameNum){
      data.add("\t\t" + "p.setValueAtTime(" + ((float(frameNum)/float(counterMax)) * (float(counterMax)/float(fps))) + ", [ " + particle[spriteNum].AEpath[frameNum].x + ", " + particle[spriteNum].AEpath[frameNum].y + "]);" + "\r");
}

void AEkeyRot(int spriteNum, int frameNum){
      data.add("\t\t" + "r.setValueAtTime(" + ((float(frameNum)/float(counterMax)) * (float(counterMax)/float(fps))) + ", " + particle[spriteNum].AErot[frameNum] +");" + "\r");
}

void AEeffects(){
     data.add("\t" + "var myEffect = solid.property(\"Effects\").addProperty(\"Fast Blur\")(\"Blurriness\").setValue(61);");
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void AEkeysBegin() {
  data = new Data();
  data.beginSave();
  data.add("{  //start script" + "\r");
  data.add("\t" + "app.beginUndoGroup(\"foo\");" + "\r");
  data.add("\r");
  data.add("\t" + "// create project if necessary" + "\r");
  data.add("\t" + "var proj = app.project;" + "\r");
  data.add("\t" + "if(!proj) proj = app.newProject();" + "\r");
  data.add("\r");
  data.add("\t" + "// create new comp named 'my comp'" + "\r");
  data.add("\t" + "var compW = " + dW + "; // comp width" + "\r");
  data.add("\t" + "var compH = " + dH + "; // comp height" + "\r");
  data.add("\t" + "var compL = " + (counterMax/fps) + ";  // comp length (seconds)" + "\r");
  data.add("\t" + "var compRate = " + fps + "; // comp frame rate" + "\r");
  data.add("\t" + "var compBG = [0/255,0/255,0/255] // comp background color" + "\r");
  data.add("\t" + "var myItemCollection = app.project.items;" + "\r");
  data.add("\t" + "var myComp = myItemCollection.addComp('my comp',compW,compH,1,compL,compRate);" + "\r");
  data.add("\t" + "myComp.bgColor = compBG;" + "\r");
  data.add("\r");  
}

void AEkeysEnd() {
  data.add("\r");
  data.add("\t" + "app.endUndoGroup();" + "\r");
  data.add("}  //end script" + "\r");
  data.endSave("data/"+ aeFilePath + "/" + aeFileName + "." + aeFileType);
}

boolean hitDetect(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  w1 /= 2;
  h1 /= 2;
  w2 /= 2;
  h2 /= 2; 
  if(x1 + w1 >= x2 - w2 && x1 - w1 <= x2 + w2 && y1 + h1 >= y2 - h2 && y1 - h1 <= y2 + h2) {
    return true;
  } 
  else {
    return false;
  }
}
