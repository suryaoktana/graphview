part of graphview;



class TreeEdgeRenderer extends EdgeRenderer {
  BuchheimWalkerConfiguration configuration;

  TreeEdgeRenderer(this.configuration);

  var linePath = Path();

  

  @override
  void render(Canvas canvas, Graph graph, Paint paint) {
    var levelSeparationHalf = configuration.levelSeparation / 2;


    graph.nodes.forEach((node) {
      var children = graph.successorsOf(node);

      children.forEach((child) {
        var edge = graph.getEdgeBetween(node, child);
        var edgePaint = (edge?.paint ?? paint)..style = PaintingStyle.stroke;
        linePath.reset();
        switch (configuration.orientation) {
          case BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM:
        
            if(child.isDottedLine){
              var pattern = [5,5,5,5];
              drawDashedLine(canvas:canvas,p1:Offset((child.x + child.width / 2), child.y), p2:Offset(child.x + child.width / 2, child.y - levelSeparationHalf), pattern:pattern,paint:edgePaint);
              drawDashedLine(canvas:canvas,p1:Offset(child.x + child.width / 2, child.y - levelSeparationHalf), p2:Offset(node.x + node.width / 2, child.y - levelSeparationHalf), pattern:pattern,paint:edgePaint);
              drawDashedLine(canvas:canvas,p1:Offset(node.x + node.width / 2, child.y - levelSeparationHalf), p2:Offset(node.x + node.width / 2, node.y + node.height), pattern:pattern,paint:edgePaint);
              

            }
            else{
              // position at the middle-top of the child
              linePath.moveTo((child.x + child.width / 2), child.y);
              // draws a line from the child's middle-top halfway up to its parent
              linePath.lineTo(child.x + child.width / 2, child.y - levelSeparationHalf);
              // draws a line from the previous point to the middle of the parents width
              linePath.lineTo(node.x + node.width / 2, child.y - levelSeparationHalf);

              // position at the middle of the level separation under the parent
              linePath.moveTo(node.x + node.width / 2, child.y - levelSeparationHalf);
              // draws a line up to the parents middle-bottom
              linePath.lineTo(node.x + node.width / 2, node.y + node.height);
            }

          

            break;
          case BuchheimWalkerConfiguration.ORIENTATION_BOTTOM_TOP:
            linePath.moveTo(child.x + child.width / 2, child.y + child.height);
            linePath.lineTo(child.x + child.width / 2, child.y + child.height + levelSeparationHalf);
            linePath.lineTo(node.x + node.width / 2, child.y + child.height + levelSeparationHalf);

            linePath.moveTo(node.x + node.width / 2, child.y + child.height + levelSeparationHalf);
            linePath.lineTo(node.x + node.width / 2, node.y + node.height);

            break;
          case BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT:
            linePath.moveTo(child.x, child.y + child.height / 2);
            linePath.lineTo(child.x - levelSeparationHalf, child.y + child.height / 2);
            linePath.lineTo(child.x - levelSeparationHalf, node.y + node.height / 2);

            linePath.moveTo(child.x - levelSeparationHalf, node.y + node.height / 2);
            linePath.lineTo(node.x + node.width, node.y + node.height / 2);

            break;
          case BuchheimWalkerConfiguration.ORIENTATION_RIGHT_LEFT:
            linePath.moveTo(child.x + child.width, child.y + child.height / 2);
            linePath.lineTo(child.x + child.width + levelSeparationHalf, child.y + child.height / 2);
            linePath.lineTo(child.x + child.width + levelSeparationHalf, node.y + node.height / 2);

            linePath.moveTo(child.x + child.width + levelSeparationHalf, node.y + node.height / 2);
            linePath.lineTo(node.x + node.width, node.y + node.height / 2);
        }

        canvas.drawPath(linePath, edgePaint);
      });
    });
  }

  void drawDashedLine({
  required Canvas canvas,
  required Offset p1,
  required Offset p2,
  required List<int> pattern,
  required Paint paint,
}) {
  assert(pattern.length.isEven);
  final distance = (p2 - p1).distance;
  final normalizedPattern = pattern.map((width) => width / distance).toList();
  final points = <Offset>[];
  double t = 0;
  int i = 0;
  while (t < 1) {
    points.add(Offset.lerp(p1, p2, t)!);
    t += normalizedPattern[i++];  // dashWidth
    points.add(Offset.lerp(p1, p2, t.clamp(0, 1))!);
    t += normalizedPattern[i++];  // dashSpace
    i %= normalizedPattern.length;
  }
  canvas.drawPoints(ui.PointMode.lines, points, paint);
}
}
