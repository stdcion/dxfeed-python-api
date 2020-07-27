from dxfeed.core.utils.helpers cimport *
from dxfeed.core.utils.handler cimport EventHandler
from collections import namedtuple

cdef class FuncWrapper:
    def __cinit__(self):
        self.func = NULL

    @staticmethod
    cdef FuncWrapper make_from_ptr(dxf_event_listener_t f):
        cdef FuncWrapper out = FuncWrapper()
        out.func = f
        return out


TRADE_COLUMNS = ['Symbol', 'Sequence', 'Price', 'ExchangeCode', 'Size', 'Tick', 'Change', 'DayVolume',
                 'DayTurnover', 'Direction', 'Time', 'Nanos', 'RawFlags', 'IsETH', 'Scope']
TradeTuple = namedtuple('Trade', ['symbol', 'sequence', 'price', 'exchange_code', 'size', 'tick', 'change',
                                  'day_volume', 'day_turnover', 'direction', 'time', 'time_nanos', 'raw_flags',
                                  'is_eth', 'scope'])
cdef void trade_default_listener(int event_type,
                                 dxf_const_string_t symbol_name,
                                 const dxf_event_data_t*data,
                                 int data_count, void*user_data) nogil:
    cdef dxf_trade_t* trades = <dxf_trade_t*> data
    with gil:
        py_data = <EventHandler> user_data

        for i in range(data_count):
            trade_event = TradeTuple(symbol=unicode_from_dxf_const_string_t(symbol_name),
                                     sequence=trades[i].sequence,
                                     price=trades[i].price,
                                     exchange_code=unicode_from_dxf_const_string_t(&trades[i].exchange_code),
                                     size=trades[i].size,
                                     tick=trades[i].tick,
                                     change=trades[i].change,
                                     day_volume=trades[i].day_volume,
                                     day_turnover=trades[i].day_turnover,
                                     direction=trades[i].direction,
                                     time=trades[i].time,
                                     time_nanos=trades[i].time_nanos,
                                     raw_flags=trades[i].raw_flags,
                                     is_eth=trades[i].is_eth,
                                     scope=trades[i].scope)
            py_data.__update(trade_event)

QUOTE_COLUMNS = ['Symbol', 'Sequence', 'Time', 'Nanos', 'BidTime', 'BidExchangeCode', 'BidPrice', 'BidSize', 'AskTime',
                 'AskExchangeCode', 'AskPrice', 'AskSize', 'Scope']
QuoteTuple = namedtuple('Quote', ['symbol', 'sequence', 'time', 'time_nanos', 'bid_time', 'bid_exchange_code',
                                  'bid_price', 'bid_size', 'ask_time', 'ask_exchange_code', 'ask_price', 'ask_size',
                                  'scope'])
cdef void quote_default_listener(int event_type,
                                 dxf_const_string_t symbol_name,
                                 const dxf_event_data_t*data,
                                 int data_count,
                                 void*user_data) nogil:
    cdef dxf_quote_t*quotes = <dxf_quote_t*> data
    with gil:
        py_data = <EventHandler> user_data

        for i in range(data_count):
            quote_event = QuoteTuple(symbol=unicode_from_dxf_const_string_t(symbol_name),
                                     sequence=quotes[i].sequence,
                                     time=quotes[i].time,
                                     time_nanos=quotes[i].time_nanos,
                                     bid_time=quotes[i].bid_time,
                                     bid_exchange_code=unicode_from_dxf_const_string_t(&quotes[i].bid_exchange_code),
                                     bid_price=quotes[i].bid_price,
                                     bid_size=quotes[i].bid_size,
                                     ask_time=quotes[i].ask_time,
                                     ask_exchange_code=unicode_from_dxf_const_string_t(&quotes[i].ask_exchange_code),
                                     ask_price=quotes[i].ask_price,
                                     ask_size=quotes[i].ask_size,
                                     scope=<int> quotes[i].scope)
            py_data.__update(quote_event)

SUMMARY_COLUMNS = ['Symbol', 'DayId', 'DayOpenPrice', 'DayHighPrice', 'DayLowPrice', 'DayClosePrice', 'PrevDayId',
                   'PrevDayClosePrice', 'PrevDayVolume', 'OpenInterest', 'RawFlags', 'ExchangeCode',
                   'DayClosePriceType', 'PrevDayClosePriceType', 'Scope']
SummaryTuple = namedtuple('Summary', ['symbol', 'day_id', 'day_open_price', 'day_high_price', 'day_low_price',
                                      'day_close_price', 'prev_day_id', 'prev_day_close_price', 'prev_day_volume',
                                      'open_interest', 'raw_flags', 'exchange_code', 'day_close_price_type',
                                      'prev_day_close_price_type', 'scope'])
cdef void summary_default_listener(int event_type, dxf_const_string_t symbol_name,
                                   const dxf_event_data_t*data, int data_count, void*user_data) nogil:
    cdef dxf_summary_t*summary = <dxf_summary_t*> data

    with gil:
        py_data = <EventHandler> user_data
        for i in range(data_count):
            summary_event = SummaryTuple(symbol=unicode_from_dxf_const_string_t(symbol_name),
                              day_id=summary[i].day_id,
                              day_open_price=summary[i].day_open_price,
                              day_high_price=summary[i].day_high_price,
                              day_low_price=summary[i].day_low_price,
                              day_close_price=summary[i].day_close_price,
                              prev_day_id=summary[i].prev_day_id,
                              prev_day_close_price=summary[i].prev_day_close_price,
                              prev_day_volume=summary[i].prev_day_volume,
                              open_interest=summary[i].open_interest,
                              raw_flags=summary[i].raw_flags,
                              exchange_code=unicode_from_dxf_const_string_t(&summary[i].exchange_code),
                              day_close_price_type=summary[i].day_close_price_type,
                              prev_day_close_price_type=summary[i].prev_day_close_price_type,
                              scope=summary[i].scope)
            py_data.__update(summary_event)

PROFILE_COLUMNS = ['Symbol', 'Beta', 'EPS', 'DivFreq', 'ExdDivAmount', 'ExdDivDate', '52HighPrice', '52LowPrice',
                   'Shares', 'FreeFloat', 'HighLimitPrice', 'LowLimitPrice', 'HaltStartTime', 'HaltEndTime',
                   'Description', 'RawFlags', 'StatusReason', 'TradingStatus', 'ShortSaleRestriction']
ProfileTuple = namedtuple('Profile', ['symbol', 'beta', 'eps', 'div_freq', 'exd_div_amount', 'exd_div_date',
                                      '_52_high_price', '_52_low_price', 'shares', 'free_float', 'high_limit_price',
                                      'low_limit_price', 'halt_start_time', 'halt_end_time', 'description', 'raw_flags',
                                      'status_reason', 'trading_status', 'ssr'])
cdef void profile_default_listener(int event_type,
                                   dxf_const_string_t symbol_name,
                                   const dxf_event_data_t*data,
                                   int data_count,
                                   void*user_data)  nogil:
    cdef dxf_profile_t*p = <dxf_profile_t*> data
    with gil:
        py_data = <EventHandler> user_data
        for i in range(data_count):
            profile_event = ProfileTuple(symbol=unicode_from_dxf_const_string_t(symbol_name),
                              beta=p[i].beta,
                              eps=p[i].eps,
                              div_freq=p[i].div_freq,
                              exd_div_amount=p[i].exd_div_amount,
                              exd_div_date=p[i].exd_div_date,
                              _52_high_price=p[i]._52_high_price,
                              _52_low_price=p[i]._52_low_price,
                              shares=p[i].shares,
                              free_float=p[i].free_float,
                              high_limit_price=p[i].high_limit_price,
                              low_limit_price=p[i].low_limit_price,
                              halt_start_time=p[i].halt_start_time,
                              halt_end_time=p[i].halt_end_time,
                              description=unicode_from_dxf_const_string_t(p[i].description),
                              raw_flags=p[i].raw_flags,
                              status_reason=unicode_from_dxf_const_string_t(p[i].status_reason),
                              trading_status=p[i].trading_status,
                              ssr=p[i].ssr)
            py_data.__update(profile_event)

TIME_AND_SALE_COLUMNS = ['Symbol', 'EventFlags', 'Index', 'Time', 'ExchangeCode', 'Price', 'Size', 'BidPrice',
                         'AskPrice', 'ExchangeSaleConditions', 'RawFlags', 'Buyer', 'Seller', 'Side', 'Type',
                         'IsValidTick', 'IsEthTrade', 'TradeThroughExempt', 'IsSpreadLeg', 'Scope']
TnSTuple = namedtuple('TnS', ['symbol', 'event_flags', 'index', 'time', 'exchange_code', 'price', 'size', 'bid_price',
                              'ask_price', 'exchange_sale_conditions', 'raw_flags', 'buyer', 'seller', 'side', 'type',
                              'is_valid_tick', 'is_eth_trade', 'trade_through_exempt', 'is_spread_leg', 'scope'])
cdef void time_and_sale_default_listener(int event_type,
                                         dxf_const_string_t symbol_name,
                                         const dxf_event_data_t*data,
                                         int data_count,
                                         void*user_data) nogil:
    cdef dxf_time_and_sale_t*tns = <dxf_time_and_sale_t*> data
    with gil:
        py_data = <EventHandler> user_data
        for i in range(data_count):
            tns_event = TnSTuple(symbol=unicode_from_dxf_const_string_t(symbol_name),
                                 event_flags=tns[i].event_flags,
                                 index=tns[i].index,
                                 time=tns[i].time,
                                 exchange_code=unicode_from_dxf_const_string_t(&tns[i].exchange_code),
                                 price=tns[i].price,
                                 size=tns[i].size,
                                 bid_price=tns[i].bid_price,
                                 ask_price=tns[i].ask_price,
                                 exchange_sale_conditions= \
                                     unicode_from_dxf_const_string_t(tns[i].exchange_sale_conditions),
                                 raw_flags=tns[i].raw_flags,
                                 buyer=unicode_from_dxf_const_string_t(tns[i].buyer),
                                 seller=unicode_from_dxf_const_string_t(tns[i].seller),
                                 side=tns[i].side,
                                 type=tns[i].type,
                                 is_valid_tick=tns[i].is_valid_tick,
                                 is_eth_trade=tns[i].is_eth_trade,
                                 trade_through_exempt=tns[i].trade_through_exempt,
                                 is_spread_leg=tns[i].is_spread_leg,
                                 scope=tns[i].scope)
            py_data.__update(tns_event)

CANDLE_COLUMNS = ['Symbol', 'EventFlags', 'Index', 'Time', 'Sequence', 'Count', 'Open', 'High', 'Low', 'Close', 'Volume', 'VWap',
                  'BidVolume', 'AskVolume', 'OpenInterest', 'ImpVolatility']
CandleTuple = namedtuple('Candle', ['symbol', 'event_flags', 'index', 'time', 'sequence', 'count', 'open', 'high',
                                    'low', 'close', 'volume', 'vwap', 'bid_volume', 'ask_volume', 'open_interest',
                                    'imp_volatility'])
cdef void candle_default_listener(int event_type,
                                  dxf_const_string_t symbol_name,
                                  const dxf_event_data_t*data,
                                  int data_count,
                                  void*user_data) nogil:
    cdef dxf_candle_t*candle = <dxf_candle_t*> data
    with gil:
        py_data = <EventHandler> user_data
        for i in range(data_count):
            candle_event = CandleTuple(symbol=unicode_from_dxf_const_string_t(symbol_name),
                                       event_flags=candle[i].event_flags,
                                       index=candle[i].index,
                                       time=candle[i].time,
                                       sequence=candle[i].sequence,
                                       count=candle[i].count,
                                       open=candle[i].open,
                                       high=candle[i].high,
                                       low=candle[i].low,
                                       close=candle[i].close,
                                       volume=candle[i].volume,
                                       vwap=candle[i].vwap,
                                       bid_volume=candle[i].bid_volume,
                                       ask_volume=candle[i].ask_volume,
                                       open_interest=candle[i].open_interest,
                                       imp_volatility=candle[i].imp_volatility)
            py_data.__update(candle_event)

ORDER_COLUMNS = ['Symbol', 'EventFlags', 'Index', 'Time', 'Nanos', 'Sequence', 'Price', 'Size', 'Count', 'Scope',
                 'Side', 'ExchangeCode', 'MarketMaker', 'SpreadSymbol']
cdef void order_default_listener(int event_type,
                                 dxf_const_string_t symbol_name,
                                 const dxf_event_data_t*data,
                                 int data_count,
                                 void*user_data) nogil:
    cdef dxf_order_t*order = <dxf_order_t*> data
    with gil:
        py_data = <EventHandler> user_data
        for i in range(data_count):
            py_data.__update([unicode_from_dxf_const_string_t(symbol_name),
                              order[i].event_flags,
                              order[i].index,
                              order[i].time,
                              order[i].time_nanos,
                              order[i].sequence,
                              order[i].price,
                              order[i].size,
                              order[i].count,
                              order[i].scope,
                              order[i].side,
                              unicode_from_dxf_const_string_t(&order[i].exchange_code),
                              unicode_from_dxf_const_string_t(order[i].market_maker),
                              unicode_from_dxf_const_string_t(order[i].spread_symbol)])

GREEKS_COLUMNS = ['Symbol', 'EventFlags', 'Index', 'Time', 'Price', 'Volatility', 'Delta', 'Gamma', 'Theta', 'Rho',
                  'Vega']
cdef void greeks_default_listener(int event_type,
                                  dxf_const_string_t symbol_name,
                                  const dxf_event_data_t*data,
                                  int data_count,
                                  void*user_data) nogil:
    cdef dxf_greeks_t*greeks = <dxf_greeks_t*> data
    with gil:
        py_data = <EventHandler> user_data
        for i in range(data_count):
            py_data.__update([unicode_from_dxf_const_string_t(symbol_name),
                              greeks[i].event_flags,
                              greeks[i].index,
                              greeks[i].time,
                              greeks[i].price,
                              greeks[i].volatility,
                              greeks[i].delta,
                              greeks[i].gamma,
                              greeks[i].theta,
                              greeks[i].rho,
                              greeks[i].vega])

THEO_PRICE_COLUMNS = ['Symbol', 'Time', 'Price', 'UnderlyingPrice', 'Delta', 'Gamma', 'Dividend', 'Interest']
cdef void theo_price_default_listener(int event_type,
                                      dxf_const_string_t symbol_name,
                                      const dxf_event_data_t*data,
                                      int data_count,
                                      void*user_data) nogil:
    cdef dxf_theo_price_t*theo_price = <dxf_theo_price_t*> data
    with gil:
        py_data = <EventHandler> user_data
        for i in range(data_count):
            py_data.__update([unicode_from_dxf_const_string_t(symbol_name),
                              theo_price[i].time,
                              theo_price[i].price,
                              theo_price[i].underlying_price,
                              theo_price[i].delta,
                              theo_price[i].gamma,
                              theo_price[i].dividend,
                              theo_price[i].interest])

UNDERLYING_COLUMNS = ['Symbol', 'Volatility', 'FrontVolatility', 'BackVolatility', 'PutCallRatio']
cdef void underlying_default_listener(int event_type,
                                      dxf_const_string_t symbol_name,
                                      const dxf_event_data_t*data,
                                      int data_count,
                                      void*user_data) nogil:
    cdef dxf_underlying_t*underlying = <dxf_underlying_t*> data
    with gil:
        py_data = <EventHandler> user_data
        for i in range(data_count):
            py_data.__update([unicode_from_dxf_const_string_t(symbol_name),
                              underlying[i].volatility,
                              underlying[i].front_volatility,
                              underlying[i].back_volatility,
                              underlying[i].put_call_ratio])

SERIES_COLUMNS = ['Symbol', 'EventFlags', 'Index', 'Time', 'Sequence', 'Expiration', 'Volatility',
                  'PutCallRatio', 'ForwardPrice', 'Dividend', 'Interest']
cdef void series_default_listener(int event_type,
                                  dxf_const_string_t symbol_name,
                                  const dxf_event_data_t*data,
                                  int data_count,
                                  void*user_data) nogil:
    cdef dxf_series_t*series = <dxf_series_t*> data
    with gil:
        py_data = <EventHandler> user_data
        for i in range(data_count):
            py_data.__update([unicode_from_dxf_const_string_t(symbol_name),
                              series[i].event_flags,
                              series[i].index,
                              series[i].time,
                              series[i].sequence,
                              series[i].expiration,
                              series[i].volatility,
                              series[i].put_call_ratio,
                              series[i].forward_price,
                              series[i].dividend,
                              series[i].interest])

CONFIGURATION_COLUMNS = ['Symbol', 'Version', 'Object']
cdef void configuration_default_listener(int event_type,
                                         dxf_const_string_t symbol_name,
                                         const dxf_event_data_t*data,
                                         int data_count,
                                         void*user_data) nogil:
    cdef dxf_configuration_t*config = <dxf_configuration_t*> data
    with gil:
        py_data = <EventHandler> user_data
        for i in range(data_count):
            py_data.__update([unicode_from_dxf_const_string_t(symbol_name),
                              config[i].version,
                              unicode_from_dxf_const_string_t(config[i].object)])
