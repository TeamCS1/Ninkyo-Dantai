///instance_nth_nearest(x,y,obj,n)
/// @func instance_nth_nearest(x,y,obj,n)
/// @desc Finds the nearest instance 
/// @arg filepath
/// @arg vformat
/// @return -1 on fail or a vbuffer ID
   
    
      /// instance_nth_nearest(x,y,obj,n)
    //
    //  Returns the id of the nth nearest instance of an object
    //  to a given point or noone if none is found.
    //
    //      x,y       point coordinates, real
    //      obj       object index (or all), real
    //      n         proximity, real
    //
    /// GMLscripts.com/license
    {
        var pointx,pointy,object,n,list,nearest;
        pointx = argument0;
        pointy = argument1;
        object = argument2;
        n = argument3;
        n = min(max(1,n),instance_number(object));
        list = ds_priority_create();
        nearest = noone;
        with (object) ds_priority_add(list,id,distance_to_point(pointx,pointy));
        repeat (n) nearest = ds_priority_delete_min(list);
        ds_priority_destroy(list);
        return nearest;
    }
