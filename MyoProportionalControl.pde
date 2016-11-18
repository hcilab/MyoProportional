MyoProportional myoProportional;


void setup() {
  frameRate(5);

  try {
    myoProportional = new MyoProportional(this);
  } catch (MyoNotDetectectedError e) {
    println("[ERROR] Could not detect armband, exiting.");
    System.exit(1);
  }

  calibrate();
}

private void calibrate() {
  try {
    SensorConfig s;

    println("Left (5 seconds):");
    delay(5000);
    s = myoProportional.registerAction(Action.LEFT);
    println("[INFO] Registered sensor " + s.sensorID + " with sensitivity " + s.maxReading + ".");

    println("Right (5 seconds):");
    delay(5000);
    s = myoProportional.registerAction(Action.RIGHT);
    println("[INFO] Registered sensor " + s.sensorID + " with sensitivity " + s.maxReading + ".");

  } catch (CalibrationFailedException e) {
    println("[ERROR] Could not successfully calibrate, exiting.");
    System.exit(2);
  }

  assert(myoProportional.isCalibrated());
}

private void loadCalibrationFile(String filename) {
  try {
    myoProportional.loadCalibrationSettings(filename);
  } catch (CalibrationFailedException e) {
    println("[ERROR] Could not load calibration settings from: " + filename + ", exiting.");
    System.exit(3);
  }
}


void draw() {
  // Adjust by:
  //  - using poll() and pollAndTrim()
  //  - using different Policies: RAW, MAXIMUM, DIFFERENCE, FIRST_OVER
  HashMap<Action, Float> readings = myoProportional.pollAndTrim(Policy.RAW);
  prettyPrint(readings);
}

private void prettyPrint(HashMap<Action, Float> data) {
  float left = data.get(Action.LEFT);
  float right = data.get(Action.RIGHT);
  float impulse = data.get(Action.IMPULSE);
  println("[L: " + nf(left, 1, 2) + "\tR: " + nf(right, 1, 2) + "\tI: " + nf(impulse, 1, 2) + "]");
}
