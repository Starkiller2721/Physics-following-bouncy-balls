void drawGravityVector(float x, float y, float forceX, float forceY) 
{
    float baseLength = 10;  // Minimum length for weak forces
    float maxLineLength = 1e5;  // Max length for extreme forces
    float forceMagnitude = dist(0, 0, forceX, forceY);

    // Nonlinear mapping: Weak forces get boosted, extreme ones are capped
    float scaleFactor = map(sqrt(forceMagnitude), 0, sqrt(1000), baseLength, maxLineLength);  
    scaleFactor = constrain(scaleFactor, baseLength, maxLineLength);

    float normX = (forceX / forceMagnitude) * scaleFactor;
    float normY = (forceY / forceMagnitude) * scaleFactor;

    stroke(0, 255, 0);
    strokeWeight(1);
    line(x, y, x + normX, y + normY);
}
