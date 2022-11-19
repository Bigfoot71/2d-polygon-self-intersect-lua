local cmp = function (x1,y1,x2,y2)
    return x1 == x2 and y1 == y2
end

local linesIntersect = function(x1,y1,x2,y2, x3,y3,x4,y4)

    local dx1, dy1 = x2 - x1, y2 - y1
    local dx2, dy2 = x4 - x3, y4 - y3
    local dx3, dy3 = x1 - x3, y1 - y3
    local d = dx1*dy2 - dy1*dx2

    if d == 0 then return false end

    local t1 = (dx2*dy3 - dy2*dx3)/d
    if t1 < 0 or t1 > 1 then return false end

    local t2 = (dx1*dy3 - dy1*dx3)/d
    if t2 < 0 or t2 > 1 then return false end

    return x1 + t1*dx1, y1 + t1*dy1

end

return function(p, filterFunc)

    local seen = setmetatable({}, {__index = function(t,k)
        local s = {}; t[k] = s; return s
    end})

    local len = #p

    local isects = {}

    for i = 1, len-1, 2 do

        local _i = i+2 < len and i+2 or 1

        local x1, y1 = p[i], p[i+1]
        local x2, y2 = p[_i], p[_i+1]

        for j = 1, len-1, 2 do

            if i ~= j then

                local _j = j+2 < len and j+2 or 1

                local x3, y3 = p[j], p[j+1]
                local x4, y4 = p[_j], p[_j+1]

                if not (
                    cmp(x1,y1, x3,y3)
                or cmp(x2,y2, x3,y3)
                or cmp(x1,y1, x4,y4)
                or cmp(x2,y2, x4,y4)
                ) then

                    local ix,iy = linesIntersect(
                        x1,y1,x2,y2, x3,y3,x4,y4
                    )

                    if ix then

                        if not (
                            cmp(ix,iy, x1,y1)
                        or cmp(ix,iy, x2,y2)
                        or cmp(ix,iy, x3,y3)
                        or cmp(ix,iy, x4,y4)
                        ) then

                            local unique = not seen[ix][iy]

                            if unique then
                                seen[ix][iy] = true
                            end

                            local collect = unique

                            if filterFunc then
                                collect = filterFunc(ix,iy, i, x1,y1, x2,y2, j, x3,y3, x4,y4, unique)
                            end

                            if collect then
                                isects[#isects+1] = ix
                                isects[#isects+1] = iy
                            end

                        end
                    end
                end
            end
        end
    end

    return (#isects > 0) and isects or nil

end
