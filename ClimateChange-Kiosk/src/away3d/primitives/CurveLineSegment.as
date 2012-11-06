﻿package away3d.primitives{    import away3d.core.base.*;	import away3d.materials.*;	    /**    * Creates a 3d curved line segment.    */     public class CurveLineSegment extends Mesh    {        private var _segment:Segment;		public var _indexes:Array;		public var _start:Vertex;		public var _control:Vertex;		public var _end:Vertex;				/**		 * Defines the starting vertex.		 */        public function get start():Vertex        {            return _start;        }        public function set start(value:Vertex):void        {			_start.x = value.x;			_start.y = value.y;			_start.z = value.z;        }				/**		 * Defines the control vertex.		 */        public function get control():Vertex        {            return _control;        }		        public function set control(value:Vertex):void        {			_control.x = value.x;			_control.y = value.y;			_control.z = value.z;        }				/**		 * Defines the ending vertex.		 */        public function get end():Vertex        {            return _end;        }		        public function set end(value:Vertex):void        {			_end.x = value.x;			_end.y = value.y;			_end.z = value.z;        }				/**		 * Sets a new material to the segment 		 */		public function set wireMaterial(mat:Material):void        { 			_segment.material = mat;		}				public function get wireMaterial():Material        { 			return _segment.material;		}		 		/**		 * Creates a new <code>CurveLineSegment</code> object.		 */        public function CurveLineSegment(start:Vertex, control:Vertex, end:Vertex, material:Material = null):void        {			_start = new Vertex(start.x, start.y, start.z);			_control = new Vertex(control.x, control.y, control.z);			_end = new Vertex(end.x, end.y, end.z);						_segment = new Segment(_start, _end, material);			_segment.defineSingleCurve(_start, _control, _end);			addSegment(_segment);						type = "CurveLineSegment";        	url = "primitive";        }        }}