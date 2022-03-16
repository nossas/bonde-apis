import HealthController from './health-controller';

test('should return status UP', () => {
    const mockReq = {};
    const mRes = { status: jest.fn().mockReturnThis(), json: jest.fn() };

    const healthController = new HealthController();
    healthController.getHealth(mockReq, mRes);

    expect(mRes.json).toHaveBeenCalled();
});