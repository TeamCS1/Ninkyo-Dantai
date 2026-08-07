///scr_VehicleCollide()
///Shared collision response for every drivable vehicle. Call from each of
///the vehicle's Collision events.
///
///Puts the vehicle back where it was before the step that put it inside
///something, then kills most of the momentum that took it there. The
///bounce is deliberately weak: enough that hitting a wall feels like
///hitting something rather than sticking to it, not enough to fling the
///vehicle back across the road.
///
///yawRate has to be damped too, which the old per-object version didn't
///do - under the bicycle model the body carries rotation independently of
///its velocity, so reverting the position alone left the vehicle spinning
///on the spot against the wall.

x = xprevious;
y = yprevious;

// Reverse and dampen the custom velocity rather than ignoring it
vx *= -0.3;
vy *= -0.3;

// Scrub the rotation as well, or it keeps pivoting while pinned
yawRate *= -0.2;
