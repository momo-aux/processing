class File {
  void save(ArrayList<Box> boxes) {
    saveJSONArray(boxesToJSONArray(boxes), "newLevel.json");
  }

  ArrayList<Box> JSONArrayToBoxes(JSONArray jsonarr) {
    ArrayList<Box> boxes= new ArrayList<Box>();
    for (int i = 0; i < jsonarr.size(); i++) {
      JSONObject box = jsonarr.getJSONObject(i); 
      boxes.add(new Box(int(box.getFloat("x")), int(box.getFloat("y")), box.getFloat("w"), box.getFloat("h"),color(box.getInt("r"), box.getInt("g"), box.getInt("b")),i));
    }
    return boxes;
  }

  JSONArray boxesToJSONArray(ArrayList<Box> boxes) {
    JSONArray jsonarr = new JSONArray();
    for (Box box : boxes) {
      JSONObject currentBox = new JSONObject();
      currentBox.setFloat("x", box.position.x);
      currentBox.setFloat("y", box.position.y);
      currentBox.setFloat("w", box.w);
      currentBox.setFloat("h", box.h);

      int r = (box.c >> 16) & 0xFF;  // Faster way of getting red(argb)
      int g = (box.c >> 8) & 0xFF;   // Faster way of getting green(argb)
      int b = box.c & 0xFF;          // Faster way of getting blue(argb)

      currentBox.setInt("r", r);
      currentBox.setInt("g", g);
      currentBox.setInt("b", b);

      jsonarr.append(currentBox);
    }
    return jsonarr;
  }
}