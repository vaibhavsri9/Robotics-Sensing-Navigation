import lcm

from gps_lcm import gps_msg

def my_data_handler(channel, data):
	msg =gps_msg.decode(data)
	print("Received message on channel \"%s\"" % channel)
	print("  timestamp = %s" % str(msg.time))
	print(" lattitude = %s" %str(msg.lat))
	print(" longtd = %s" %str(msg.longtd))
	print(" altitude = %s" %str(msg.altitude))
	print(" utm_x =%s" %str(msg.utm_x))
	print(" utm_y =%s" %str(msg.utm_y))
	print("")

lc = lcm.LCM()
subscription = lc.subscribe("GPS_DATA", my_data_handler)

try:
 while True:
	lc.handle()
except KeyboardInterrupt:
	pass

lc.unsubscribe(subscription)
