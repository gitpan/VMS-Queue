use VMS::Queue;
$foo{QUEUE} = 'test_queue';
$Status = VMS::Queue::create_queue(\%foo);
