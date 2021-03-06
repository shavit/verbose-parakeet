defmodule ExRTMP.ControlMessage do
  @moduledoc """
  `ExRTMP.ControlMessage` RTMP control message

  Control messages are not AMF encoded. They start with a stream Id of 0x02 
    which implies a full (type 0) header and have a message type of 0x04, then
    followed by 6 bytes.
  """

  @typep ping_type() :: atom()

  @control_type %{
    0x0 => :clear_stream,
    0x01 => :clear_buffer,
    0x02 => :stream_dry,
    0x03 => :client_buffer_time,
    0x04 => :reset_stream,
    0x06 => :client_pinged,
    0x07 => :client_ponged,
    0x08 => :udp_request,
    0x09 => :udp_response,
    0x0A => :bandwidth_limit,
    0x0B => :bandwidth,
    0x0C => :throttle_bandwidth,
    0x0D => :stream_created,
    0x0E => :stream_deleted,
    0x0F => :set_read_access,
    0x10 => :set_write_access,
    0x11 => :stream_meta_request,
    0x12 => :stream_meta_response,
    0x13 => :get_segment_boundary,
    0x14 => :set_segment_boundary,
    0x15 => :on_disconnect,
    0x16 => :set_critical_link,
    0x17 => :disconnect,
    0x18 => :hash_update,
    0x19 => :hash_timeout,
    0x1A => :hash_request,
    0x1B => :hash_response,
    0x1C => :check_bandwidth,
    0x1D => :set_audio_sample_acceses,
    0x1E => :set_video_sample_acceses,
    0x1F => :throttle_begin,
    0x20 => :throttle_end,
    0x21 => :drm_notify,
    0x22 => :rtmfp_sync,
    0x23 => :query_ihello,
    0x24 => :forward_ihello,
    0x25 => :redirect_ihello,
    0x26 => :notify_eof,
    0x27 => :proxy_continue,
    0x28 => :proxy_remove_upstream,
    0x29 => :rtmfp_set_keepalive,
    0x2E => :segment_not_found
  }

  for {type, control_name} <- @control_type do
    def unquote(control_name)(_arg_1, _arg_2) do
      timestamp = :erlang.timestamp() |> elem(0)
      <<unquote(type)::16, timestamp::32>>
    end

    @doc """
    decode/1 interpreted a unquote(control_name) control message
    """
    def decode(<<unquote(type)::16, timestamp::32>>) do
      %{type: unquote(control_name), timestamp: timestamp}
    end

    def get_type(unquote(type)), do: unquote(control_name)
  end

  @doc """
  new/1 creates a new control message
  """
  def new(_ping_type) do
    # timestamp = :erlang.timestamp() |> elem(0)
    # header = <<0x02, timestamp::32>>
    ping_type = {0x07, :client_ponged} |> elem(0)
    # ping_type = {0x06, :client_pinged} |> elem(0)
    # header = <<0x02, timestamp::32, ping_type::16>>

    timestamp = :erlang.timestamp() |> elem(0)
    length = 6
    message_stream_id = 0
    header = <<0x02, length::24, timestamp::24, ping_type, message_stream_id::32>>
    body = <<0, 6, 8, 54, 223, 10>>

    header <> body
  end

  def decode(msg) do
    {:error, :invalid_format}
  end
end
