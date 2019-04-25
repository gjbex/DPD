PI = 3.14
data_file = open(file_name, 'r')
for line in data_file:
    data = parse_line(line)
    if is_valid(data):
        avg_angle = compute_avg_angle(data)
        if avg_angle < PI:
            display_output(avg_angle)
data_file.close()

