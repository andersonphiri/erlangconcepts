%%%-------------------------------------------------------------------
%%% @author phiri
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 4月 2024 15:55
%%%-------------------------------------------------------------------
-module(record_types).
-author("phiri").
%% API
-export([test_function/0]).
%% -record(Name, {Field}


%%% - type my_camera() :: {'cam', reference(), port()}.
%%%- type my_proc() :: {'proc', pid()}.
%%%- type my_money(Dollars, Cents) :: {dollars, Dollars, cents , Cents}.

%%%% defining types using records
%%% the format is:
%%%- record(my_record, {camera::my_camera(), cost::my_money() }).

%%%%% record keys with default values
- record(camera_dimensions, {length = 0 :: number(), width = 0 :: number(), height = 0:: number()}).
%% -opaque camera_dimensions() :: #camera_dimensions{}.
-spec handle_camera_dimensions(Camera_Dimension :: #camera_dimensions{}, State :: any())  -> #camera_dimensions{}.
-spec handle_camera_dimen(Camera_Dimension :: #camera_dimensions{}, State :: { length | width | height , Data :: number()})  -> #camera_dimensions{}.


%%% nested records
-record(camera, {name :: string(), dimen :: #camera_dimensions{}}).

test_function() ->
  MyDefaultRecord = #camera_dimensions{ _ = 0} , %% all three fields are assigned 0
  io:format("my default record value: ~p~n",[MyDefaultRecord]),
  MyRecord = #camera_dimensions{length = 4, width = 5, height = 6},
  io:format("record value: ~p~n",[MyRecord]),
  Length = MyRecord#camera_dimensions.length,
  UpdatedRecord = MyDefaultRecord#camera_dimensions{height = 900},
  io:format("the length of my record is: ~p~n", [Length]),
  io:format("updated record value: ~p~n",[UpdatedRecord]),
  Updated_Length = handle_camera_dimensions(UpdatedRecord, {length, 30000}),
  io:format("updated record length value: ~p~n",[Updated_Length]),
  UpdatedDimen = handle_camera_dimen(MyRecord, {width, 45000}),
  io:format("updated dimen record width value: ~p~n",[UpdatedDimen]),
  MyNestedRecord = #camera{name = "C920", dimen = UpdatedDimen},
  NestedWidth = MyNestedRecord#camera.dimen#camera_dimensions.width,
  io:format("nested record: ~p ~nis realy camera: ~p~nWith width extracted: ~p~n",[MyNestedRecord, verify_is_camera(MyNestedRecord#camera.dimen), NestedWidth]),
  WidthFieldIndex = #camera_dimensions.width,
  io:format("my record struct size: ~p and has fileds: ~p~n",[record_info(size, camera_dimensions), record_info(fields, camera_dimensions)]),
  io:format("fields indexes: width = ~p, length = ~p , height= ~p ~n", [WidthFieldIndex,#camera_dimensions.length, #camera_dimensions.height]).



handle_camera_dimensions(Camera_Dimension, {height, Height}) when Camera_Dimension==#camera_dimensions{_ = 0} ->
  Camera_Dimension#camera_dimensions{ height = Height };
handle_camera_dimensions(Camera_Dimension, {height, Height})  ->
  Camera_Dimension#camera_dimensions{ height = Height };


handle_camera_dimensions(Camera_Dimension, {length, Length}) when Camera_Dimension#camera_dimensions.length =< 55 ->
  Camera_Dimension#camera_dimensions{ length = Length  };

handle_camera_dimensions(Camera_Dimension, {length, Length})  ->
  Camera_Dimension#camera_dimensions{ length = Length  }.

handle_camera_dimen(Camera_Dimension, {Prop, Data})  ->
  case Prop of
    length when Data >= 4 orelse Data =< 8 -> Camera_Dimension#camera_dimensions{ length = Data  };
    width -> Camera_Dimension#camera_dimensions{ width = Data  };
    height -> Camera_Dimension#camera_dimensions{ height = Data  }
  end.

verify_is_camera(Camera_Dimension) when is_record(Camera_Dimension, camera_dimensions) ->
  true;
verify_is_camera(_Camera_Dimension) ->
  false.


