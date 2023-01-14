const std = @import("std");
const zap = @import("zap");
const Endpoints = @import("endpoints.zig");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    // setup listener
    var listener = zap.SimpleEndpointListener.init(
        allocator,
        .{
            .port = 3000,
            .on_request = null,
            .log = true,
        },
    );

    Endpoints.init(allocator, "/user", "/list");

    // add endpoints
    try listener.addEndpoint(Endpoints.getUserEndpoint());
    try listener.addEndpoint(Endpoints.getUserListEndpoint());

    // fake some users
    var uid: usize = undefined;
    uid = try Endpoints.getUsers().addByName("renerocksai", null);
    std.debug.print("Added user {}\n", .{uid});
    uid = try Endpoints.getUsers().addByName("renerocksai", "your mom");
    std.debug.print("Added user {}\n", .{uid});

    // listen
    try listener.listen();

    std.debug.print("Listening on 0.0.0.0:3000\n", .{});

    // and run
    zap.start(.{
        .threads = 2,
        .workers = 2,
    });
}