
# 2d-polygon-self-intersections-lua
This is a Lua port of JS library **[2d-polygon-self-intersections](https://github.com/tmpvar/2d-polygon-self-intersections)** to find self-intersections in a 2d polygon.

This library may not be fast, but it is robust. Robust in the fact that it will find all of the self-intersections in a polygon - minus of course shared endpoints.

You can expect a time complexity of O(n^2)

## How to use it

```lua
local intersections = require("intersections")

local poly = { 0,0, 10,0, 0,10, 10,10 }

local isects = intersections(poly)

for i=1,#isects-1,2 do
    print("x: "..isects[i], "y: "..isects[i+1])
end

-- outputs: x: 5    y: 5
```

### Description

__intersections__(`polygon`, `filterFunc`)

* `polygon` - A table with a sequence of vertices (i.e. a triangle `{ 0,0, 10,0, 10,10 }`) 
* `filterFunc` - A filter function called whenever an intersection is found: `filterFunc`(`ix`,`iy`, `i`, `x1`,`y1`, `x2`,`y2`, `j`, `x3`,`y3`, `x4`,`y4`, `unique`)
 * `ix,iy` - current intersection (e.g. `x: 5, y: 5`) - mutations in this array get collected
 * `i` - index of the segment (e.g `1`)
 * `x1,y1` - start of the first segment (e.g `0,5`)
 * `x2,y2` - start of the first segment (e.g `10,5`)
 * `j` - index of the segment (e.g `3`)
 * `x3,y3` - start of the first segment (e.g `5,0`)
 * `x4,y4` - start of the first segment (e.g `5,10`)
 * `unique` - boolean representing whether or not this intersection point has been seen before
 * __return__ `true` to collect and `false` to discard

__returns__ `nil` if no intersection is found or a table listing all intersections in a row.

_NOTE_: this library assumes the polygon is closed, so manually adding the start point as the end point has no effect.

Also note that there are 2 intersections per crossing, this library by default will only report one - all intersections will be unique.  This behavior can be changed with the `filterFunc`.

## License

[MIT](LICENSE)
